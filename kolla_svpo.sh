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
# Leta igenom alla matchande kataloger
for dir in $BASE_PATH; do


    # Kontrollera om det är en katalog
    if [ -d "$dir" ]; then
        if [ ! -f "$dir/i18n/sv.po" ] && [ ! -f "$dir/i18n/sv_SE.po" ]; then

           # Extrahera modulnamn (sista delen i sökvägen)
           module_name=$(basename "$dir")

           # Extrahera modulbasnamn efter "odooext-OCA-"
           OCA_path=$(echo "$dir" | sed -E 's#.*/odooext-OCA-([^/]+)/.*#\1#')
           echo "Saknas: $dir"
           # Bygg URL
           OCA_URL="https://translation.odoo-community.org/projects/${OCA_path}-${ODOO_VERSION}-0/${OCA_path}-${ODOO_VERSION}-0-${module_name}/"
           echo "$OCA_URL"
           echo ""
        fi
    fi
done


