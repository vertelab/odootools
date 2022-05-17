#!/usr/bin/python3
import re
import os
import logging
import sys
import argparse

from collections import defaultdict
from lxml import etree
from ast import literal_eval
from glob import glob

_logger = logging.getLogger(__file__)

REGEXES = ["odoo-*/*/__manifest__.py", "odooext-*/*/__manifest__.py"]
CORE_REGEX = ["core-odoo/addons/*/__manifest__.py"]

QUOTE = "[\"']"
NOT_QUOTE = "[^\"']"

# TODO:
# * Add multiline _inherits
# * Include *.po files and their includes (see odooext-sks/sks_translation)
# * When using mulitline _inherits, remove '_name'? (Probably, possibly discussion point, at minimum for verbose-print)
# * Add flags to ease use (for example, verbose)
# * Add psql-integration to find active modules


RECURSIVE_ERROR = set()


def recursive_error(name):
    if name[-1] not in RECURSIVE_ERROR:
        RECURSIVE_ERROR.add(name[-1])
        _logger.error(f"Recursive import error for module {name}")


class FileParser:
    def __init__(self):
        self.parsed_files = {}
        self.read_files = {}
        self.known_fileext = [".xml", ".py"]

    def parse_file(self, path):
        _, fileext = os.path.splitext(path)
        if path not in self.parsed_files:
            parsed_data = []
            if fileext in self.known_fileext:
                if fileext == ".py":
                    data = self.read_file(path)
                    parsed_data = [
                        x.strip()
                        for x in data.split("\n")
                        if not x.strip().startswith("#")
                    ]
                elif fileext == ".xml":
                    try:
                        parsed_data = etree.parse(path)
                        etree.strip_tags(parsed_data, etree.Comment)
                    except Exception as e:
                        pass
            self.parsed_files[path] = parsed_data
        return self.parsed_files.get(path)

    def read_file(self, path):
        if path not in self.read_files:
            try:
                with open(path) as f:
                    self.read_files[path] = f.read()
            except Exception as e:
                _logger.error(f"Error reading file {path}: {e}")
        return self.read_files.get(path)


file_parser = FileParser()


def find_modules(include_core=True):
    for regex in REGEXES + CORE_REGEX:
        path = os.path.join(root_path, regex)
        for manifest_path in glob(path):
            yield manifest_path


def find_defining_modules(name, modules):
    for module in modules.values():
        if name in module.names:
            yield module.name


class Module:

    _code_regexes = None

    @classmethod
    def _get_code_regexes(cls):
        if cls._code_regexes is None:
            regexes = defaultdict(lambda: defaultdict(lambda: defaultdict(list)))

            regexes["py"]["singleline"]["inherits"].append(
                re.compile(f"^ *_inherit *= *{QUOTE}({NOT_QUOTE}*){QUOTE} *$")
            )
            regexes["py"]["singleline"]["inherits"].append(
                re.compile(f"^ *comodel_name={QUOTE}({NOT_QUOTE}*){QUOTE}.*$")
            )
            regexes["py"]["singleline"]["inherits"].append(
                re.compile(f"^.*request\.env\[{QUOTE}({NOT_QUOTE}*){QUOTE}\].*$")
            )
            regexes["py"]["singleline"]["inherits"].append(
                re.compile(f"^.*self\.env\[{QUOTE}({NOT_QUOTE}*){QUOTE}\].*$")
            )

            regexes["py"]["multiline"]["inherits"].append(
                f"self\.env\[{QUOTE}({NOT_QUOTE}*){QUOTE}\]"
            )
            regexes["py"]["multiline"]["inherits"].append(
                f"request\.env\[{QUOTE}({NOT_QUOTE}*){QUOTE}\]"
            )
            regexes["py"]["multiline"]["inherits"].append(
                (
                    re.compile(f"_inherit *= *\[([^]]*)\]"),
                    re.compile(f"{QUOTE}({NOT_QUOTE}*){QUOTE}"),
                )
            )

            regexes["py"]["singleline"]["names"].append(
                re.compile(f"^ *_name *= *{QUOTE}({NOT_QUOTE}*){QUOTE} *$")
            )
            regexes["py"]["singleline"]["names"].append(
                re.compile(
                    f"^ *_name *= _description = *{QUOTE}({NOT_QUOTE}*){QUOTE} *$"
                )
            )  # Special case for core

            cls._code_regexes = regexes
        return cls._code_regexes

    def __init__(self, path):
        self.name = os.path.basename(os.path.dirname(path))
        self.path = path
        self.package = os.path.basename(os.path.dirname(os.path.dirname(path)))

        self.depends = set()
        self.inherits = set()
        self.names = set()

    def parse_deps(self):
        if not self.depends:
            manifest = literal_eval(file_parser.read_file(self.path))
            if manifest and "depends" in manifest:
                self.depends = set(manifest.get("depends"))
        return self.depends

    def parse_code(self):
        for path in glob(
            os.path.join(os.path.dirname(self.path), "**/*"), recursive=True
        ):
            if include_test_code is False and "/tests/" in path:
                continue
            data = file_parser.parse_file(path)
            _, ext = os.path.splitext(path)
            if ext == ".py":
                self.parse_py(data, Module._get_code_regexes()["py"])
            elif ext == ".xml":
                self.parse_xml(data, Module._get_code_regexes()["xml"])

    def parse_py(self, data, regexes):
        for line in data:
            for key, regex_list in regexes["singleline"].items():
                for regex in regex_list:
                    if res := re.search(regex, line):
                        getattr(self, key).add(res.groups()[0])

        one_line_file = " ".join(data)
        for key, regex_list in regexes["multiline"].items():
            for regex in regex_list:
                if not isinstance(regex, tuple):
                    getattr(self, key).update(re.findall(regex, one_line_file))
                else:
                    for match in re.findall(regex[0], one_line_file):
                        getattr(self, key).update(re.findall(regex[1], match))

    def parse_xml(self, data, regexes):
        if not data:
            return
        self.names.update(f"{self.name}.{x}" for x in data.xpath("//record/@id") if x)
        self.inherits.update(data.xpath("//field[@name='inherit_id']/@ref"))

    def validate_names(self, modules):
        count = 0
        total = len(self.inherits)
        for inherit in self.inherits:
            if not self.validate_name(inherit, modules, history=[], first_call=True):
                count += 1
                message = f"{self.package}/{self.name} missing dependency for {inherit}"
                if verbose:
                    if defining_modules := ", ".join(
                        find_defining_modules(inherit, modules)
                    ):
                        message += f" (defined in modules: [{defining_modules}])"
                    else:
                        message += " (not defined in any module)"
                print(message)
        return count, total

    def validate_name(self, name, modules, history, first_call=False):
        if name in self.names:
            return True
        if self.name in history:
            recursive_error(history)
            return False
        else:
            history.append(self.name)
        if first_call:
            internal_name = f"{self.name}.{name}"
            if internal_name in self.names:
                return True
        for dep in self.depends:
            dep_module = modules.get(dep)
            if dep_module and dep_module.validate_name(name, modules, history.copy()):
                return True
        return False


def check_missing(module_file):
    modules = {}
    for path in find_modules():
        module = Module(path)
        modules[module.name] = module
        module.parse_code()
        module.parse_deps()

    count = 0
    total = 0
    if module_file:
        with open(module_file) as f:
            module_list = (
                modules[x.strip()] for x in f.read().split("\n") if x.strip()
            )
    else:
        module_list = sorted(
            modules.values(), key=lambda x: x.package + "_" * 100 + x.name
        )

    for module in module_list:
        if validate_core is False and module.package == "addons":
            continue
        dcount, dtotal = module.validate_names(modules)
        count += dcount
        total += dtotal

    print(f"Found {count} errors in {total} checks")


def check_dependency(dependency):
    raise NotImplementedError


def check_consequence(consequence):
    raise NotImplementedError


if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        description=f"{os.path.basename(__file__)}: Tool to find and parse module relations"
    )

    main_operations = parser.add_mutually_exclusive_group(
        required=True
    )  # "Main operations")
    main_operations.add_argument(
        "-m",
        "--missing",
        dest="MISSING",
        action="store_true",
        help="Finds missing dependencies in modules",
    )
    main_operations.add_argument(
        "-d",
        "--dependency",
        dest="DEPENDENCY",
        action="store",
        default=None,
        help="Lists all modules in the given modules dependency tree",
    )
    main_operations.add_argument(
        "-c",
        "--consequence",
        dest="CONSEQUENCE",
        action="store",
        default=None,
        help="Lists all modules that has the given module in their dependency tree",
    )

    output_operations = parser.add_argument_group("Output operations")
    output_operations.add_argument(
        "-v",
        "--verbose",
        dest="VERBOSE",
        action="store_true",
        help="Gives more output data",
    )

    filtering_operations = parser.add_argument_group(
        "Filtering operations for 'missing' functionallity"
    )
    filtering_operations.add_argument(
        "--include-test-code", dest="INCLUDE_TEST_CODE", action="store_true"
    )
    filtering_operations.add_argument(
        "--skip-validate-core", dest="SKIP_VALIDATE_CORE", action="store_true"
    )
    filtering_operations.add_argument(
        "--add-regex", dest="ADD_REGEX", action="append", default=[]
    )
    filtering_operations.add_argument(
        "--file",
        dest="MODULE_FILE",
        action="store",
        default=None,
        help="Path to file containing modules separated with newlines that should be checked",
    )

    standard_settings = parser.add_argument_group("Standard settings")
    standard_settings.add_argument(
        "--root-path", dest="ROOT_PATH", default="/usr/share", action="store"
    )

    args = parser.parse_args()

    verbose = args.VERBOSE
    include_test_code = args.INCLUDE_TEST_CODE
    validate_core = not args.SKIP_VALIDATE_CORE
    root_path = args.ROOT_PATH

    REGEXES += args.ADD_REGEX

    if args.MISSING:
        check_missing(args.MODULE_FILE)
    elif args.DEPENDENCY:
        check_dependency(args.DEPENDENCY)
    elif args.CONSEQUENCE:
        check_consequence(args.CONSEQUENCE)
