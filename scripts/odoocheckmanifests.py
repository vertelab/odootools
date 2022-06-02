import sys
import os
import re

from glob import glob
from ast import literal_eval
from argparse import ArgumentParser
from itertools import chain
from collections import defaultdict



# TODO: There's currently a bug where if a manifest does not have a specific attribute it will not be
# noticed by the script. This needs to be fixed.

def verify_results(path, manifest_path):
    with open(manifest_path) as file_handle:
        template_data = get_data(manifest_path, file_handle)
        template_data = {k: list(v.keys())[0] for k, v in template_data.items()}

    all_data = get_all_data(path)

    error_found = False

    reverse_errors = defaultdict(list)

    for key, value in template_data.items():
        if key not in all_data:
            print(f"Missing {repr(key)} from all manifest files")
            continue
        header_printed = False
        for k, v in all_data[key].items():
            try:
                k = "".join(k)
            except:
                pass
            if k == value or re.match(value[1:-1], k[1:-1]):
                continue
            if not header_printed:
                header_printed = True
                print(f"Incorrekt value for attribute {repr(key)}:")
            printed_value = k if k not in ("''", '""') else 'No value'
            print(f"    {printed_value}:")
            print("        * " + "\n        * ".join(v))

            for module in v:
                reverse_errors[module].append((key, printed_value))

        if header_printed:
            print()
        error_found = error_found or header_printed

    if reverse_errors:
        print("Updates required:")
        for module, attributes in reverse_errors.items():
            print(f"    {module}")
            for attribute in attributes:
                print(f"        * {attribute[0]} - {attribute[1]}")
    return error_found


def get_data(file_path, file_handle):
    d_res = defaultdict(lambda: defaultdict(set))
    try:
        mf = literal_eval(file_handle.read())
    except ValueError:
        return None

    module_name = os.path.basename(os.path.dirname(file_path))
    for a in mf:
        val = mf.get(a)
        try:
            val = val.strip()
        except:
            pass
        val = repr(val)

        d_res[a][val].add(module_name)

    return d_res


def update_res(res, delta_res):
    for attribute, values in delta_res.items():
        for value, modules in values.items():
            res[attribute][value].update(modules)


def get_all_data(path):
    res = defaultdict(lambda: defaultdict(set))
    for file_path, file_handle in get_manifests(path):
        if delta_res := get_data(file_path, file_handle):
            update_res(res, delta_res)
    return res


def print_results(path, arguments):
    res = get_all_data(path)
    for attrib in arguments or res:
        print(f"{attrib}:")
        kv = [(len(modules), option) for option, modules in res[attrib].items()]
        kv.sort(reverse=True)
        for v, k in kv:
            print(f"  {k}: {v}")


def get_manifests(path):
    for p in chain(glob(os.path.join(path, '**/__manifest__.py'), recursive=True),
                   glob(os.path.join(path, '**/__openerp__.py'), recursive=True)):
        with open(p) as file_handle:
            yield p, file_handle


if __name__ == "__main__":
    parser = ArgumentParser("Checks recursively from current directory, finds manifest files and prints the given string in them")

    parser.add_argument("-a", "--argument", dest="ARGUMENTS", default=[], action="append", help="The arguments to look for and print, can be given multiple times")
    parser.add_argument("-t", "--template", dest="TEMPLATE", default=False, action="store_true", help="Compare against template file")
    parser.add_argument("-f", "--template-file", dest="TEMPLATE_FILE", default=None, action="store", help="Give a different template file")

    args = parser.parse_args()

    if not args.TEMPLATE:
        print_results(os.getcwd(), args.ARGUMENTS)
    else:
        template_file = args.TEMPLATE_FILE or os.path.join(os.path.dirname(__file__), "manifest_template.py")
        sys.exit(verify_results(os.getcwd(), template_file))

