import polib
import deepl
import getopt
import sys

DEEPL_API_TOKEN = "insert deepL api token here!"

global argv
global opts
global args

argv = sys.argv[1:]
opts, args = getopt.getopt(argv, "f:l:")

def translate(text, lang):
    translator = deepl.Translator(DEEPL_API_TOKEN)
    return str(translator.translate_text(text, target_lang=lang))

def get_filename():
    # read arguments from command line
    for opt, arg in opts:
        if opt in ['-f']:
            filename = arg
    if not filename:
            print('Please enter the filename of the PO file e.g. /directory/django.po:')
            filename = input()
    return filename

def get_target_language():
    # read arguments from command line
    for opt, arg in opts:
        if opt in ['-l']:
            lang = arg
    if not lang:
            print('Please enter two letter ISO language code e.g. DE:')
            lang = input()
    return lang

def process_file(filename, lang):
    po = polib.pofile(filename)
    for entry in po.untranslated_entries():
        if not entry.msgstr:
            print(entry.msgid)
            print('translating...')
            entry.msgstr = translate(entry.msgid, lang)
            print(entry.msgstr)
            print('\n')
        po.save(filename)

if __name__ == '__main__':
    process_file(get_filename(), get_target_language())
