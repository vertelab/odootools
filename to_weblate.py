#!/usr/bin/env python3
import csv
import sys

## chmod x+ to_weblate.py

# To run file:
# ./to_weblate.py source-target.csv output.tbx
# "source-target.csv" = exported file, komma seperated
# script works with Odoo Weblate: https://translate.odoo.com/projects/odoo-glossaries/-/sv/


# ---- Inställningar ----
source_lang = "en"
target_lang = "sv"

if len(sys.argv) != 3:
    print("Usage: python to_weblate.py <input_csv> <output_tbx>")
    sys.exit(1)

csv_file = sys.argv[1]
tbx_file = sys.argv[2]


def xml_escape(text):
    return (text.replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace('"', "&quot;")
                .replace("'", "&apos;"))

with open(csv_file, newline='', encoding='utf-8') as csvfile:
    reader = csv.DictReader(csvfile)
    entries = [(row['source'], row['target']) for row in reader]

with open(tbx_file, "w", encoding="utf-8") as f:
    # Header + DOCTYPE
    f.write('<?xml version="1.0" encoding="UTF-8"?>\n')
    f.write('<!DOCTYPE martif PUBLIC "ISO 12200:1999A//DTD MARTIF core (DXFcdV04)//EN" "TBXcdv04.dtd">\n')
    f.write(f'<martif type="TBX" xml:lang="{source_lang}">\n')
    f.write('    <martifHeader>\n')
    f.write('        <fileDesc>\n')
    f.write('            <sourceDesc>\n')
    f.write('                <p>Translate Toolkit</p>\n')
    f.write('            </sourceDesc>\n')
    f.write('        </fileDesc>\n')
    f.write('    </martifHeader>\n')
    f.write('    <text>\n')
    f.write('        <body>\n')

    for src, tgt in entries:
        f.write('            <termEntry>\n')
        f.write(f'                <langSet xml:lang="{source_lang}"><tig><term>{xml_escape(src)}</term></tig></langSet>\n')
        f.write(f'                <langSet xml:lang="{target_lang}"><tig><term>{xml_escape(tgt)}</term></tig></langSet>\n')
        f.write('            </termEntry>\n')
        f.write('\n')

    f.write('        </body>\n')
    f.write('    </text>\n')
    f.write('</martif>\n')

print(f"TBX-fil skapad: {tbx_file}")



