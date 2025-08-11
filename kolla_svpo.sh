#!/bin/bash
# 
# Sökvägens mönster
BASE_PATH="/usr/share/odoo-*/*"

echo "Vertel: Letar efter kataloger där 'sv.po' saknas..."

# Leta igenom alla matchande kataloger
for dir in $BASE_PATH; do
    # Kontrollera om det är en katalog
    if [ -d "$dir" ]; then
        if [ ! -f "$dir/i18n/sv.po" ] && [ ! -f "$dir/i18n/sv_SE.po" ]; then
            echo "Saknas: $dir"
        fi
    fi
done

echo " "
echo "..."
echo " "

# Sökvägens mönster
BASE_PATH="/usr/share/odooext-OCA*/*"

echo "OCA: Letar efter kataloger där 'sv.po' saknas..."

# Leta igenom alla matchande kataloger
for dir in $BASE_PATH; do
    # Kontrollera om det är en katalog
    if [ -d "$dir" ]; then
        if [ ! -f "$dir/i18n/sv.po" ] && [ ! -f "$dir/i18n/sv_SE.po" ]; then
            echo "Saknas: $dir"
        fi
    fi
done

