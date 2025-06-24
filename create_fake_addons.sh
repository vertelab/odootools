#!/bin/bash

SOURCE_DIR="/usr/share"
TARGET_DIR="$HOME/fake_addons"

ADDONS_PROJECTS=(
"odoo-account"
"odoo-ai"
"odoo-base"
"odoo-calendar"
"odoo-contract"
"odoo-crm"
"odoo-customer-addons"
"odoo-digitalworkplace"
"odoo-document"
"odoo-event"
"odoo-helpdesk"
"odoo-hr"
"odoo-imagemagick"
"odoo-l10n_se"
"odoo-l10n_se_payroll"
"odoo-mail"
"odoo-maintenance"
"odoo-oca-server-backend"
"odoo-oca-web"
"odoo-oca-website"
"odoo-payroll"
"odoo-planning"
"odoo-product"
"odoo-project"
"odoo-project_scrum"
"odoo-recruitment"
"odoo-report"
"odoo-sale"
"odoo-server-tools"
"odoo-stock"
"odoo-theme-vertel"
"odoo-time-report"
"odoo-user-mail"
"odoo-utm"
"odoo-web"
"odoo-website"
"odoo-website-blog"
"odoo-website-dermanord"
"odoo-website-quote"
"odoo-website-sale"
)

for project in "${ADDONS_PROJECTS[@]}"; do
    for module in "$SOURCE_DIR/$project"/*/; do
        [ -d "$module" ] || continue
        modname=$(basename "$module")
        dest="$TARGET_DIR/$project/$modname"
        mkdir -p "$dest"
        # Copy manifest and __init__.py
        for file in "__manifest__.py" "__openerp__.py" "__init__.py"; do
            [ -f "$module/$file" ] && cp "$module/$file" "$dest/"
        done
        # Copy Python files in module root except manifest and __init__
        for pyfile in "$module"/*.py; do
            fname=$(basename "$pyfile")
            if [[ "$fname" != "__manifest__.py" && "$fname" != "__openerp__.py" && "$fname" != "__init__.py" ]]; then
                [ -f "$pyfile" ] && cp "$pyfile" "$dest/"
            fi
        done

        # Copy xml files in module root
        for xmlfile in "$module"/*.xml; do
            [ -f "$xmlfile" ] && cp "$xmlfile" "$dest/"
            [ -f "$xmlfile" ] && echo "<odoo></odoo>" > "$dest/$(basename "$xmlfile")"
        done

        # Copy models folder and its Python files
        if [ -d "$module/models" ]; then
            mkdir -p "$dest/models"
            for pyfile in "$module/models"/*.py; do
                [ -f "$pyfile" ] && cp "$pyfile" "$dest/models/"
            done
        fi
        
        # Copy model folder and its Python files
        if [ -d "$module/model" ]; then
            mkdir -p "$dest/model"
            for pyfile in "$module/model"/*.py; do
                [ -f "$pyfile" ] && cp "$pyfile" "$dest/model/"
            done
        fi

        # Copy tools folder and its Python files
        if [ -d "$module/tools" ]; then
            mkdir -p "$dest/tools"
            for pyfile in "$module/tools"/*.py; do
                [ -f "$pyfile" ] && cp "$pyfile" "$dest/tools/"
            done
        fi

        # Copy and empty XML files in views and data
        for subdir in views view data templates snippets demo; do
            if [ -d "$module/$subdir" ]; then
                mkdir -p "$dest/$subdir"
                for xml in "$module/$subdir"/*.xml; do
                    [ -f "$xml" ] && echo "<odoo></odoo>" > "$dest/$subdir/$(basename "$xml")"
                done
                for csv in "$module/$subdir"/*.csv; do
                    [ -f "$csv" ] && echo "id,name" > "$dest/$subdir/$(basename "$csv")"
                done

            fi
        done

        # Copy and empty XML files in security
        for subdir in security; do
            if [ -d "$module/$subdir" ]; then
                mkdir -p "$dest/$subdir"
                for xml in "$module/$subdir"/*.xml; do
                    [ -f "$xml" ] && echo "<odoo></odoo>" > "$dest/$subdir/$(basename "$xml")"
                done
                for csv in "$module/$subdir"/*.csv; do
                    [ -f "$csv" ] && echo "id,name,model_id:id,group_id:id,perm_read,perm_write,perm_create,perm_unlink" > "$dest/$subdir/$(basename "$csv")"
                done

            fi
        done

        # Copy and empty controllers files
        if [ -d "$module/controllers" ]; then
            mkdir -p "$dest/controllers"
            for ctrlfile in "$module/controllers"/*; do
                [ -f "$ctrlfile" ] && : > "$dest/controllers/$(basename "$ctrlfile")"
            done
        fi

        # Copy and empty controller files
        if [ -d "$module/controller" ]; then
            mkdir -p "$dest/controller"
            for ctrlfile in "$module/controller"/*; do
                [ -f "$ctrlfile" ] && : > "$dest/controller/$(basename "$ctrlfile")"
            done
        fi

        if [ -d "$module/wizard" ]; then
            mkdir -p "$dest/wizard"
            for ctrlfile in "$module/wizard"/*.py; do
                [ -f "$ctrlfile" ] && : > "$dest/wizard/$(basename "$ctrlfile")"
            done
            for ctrlfile2 in "$module/wizard"/*.xml; do
                [ -f "$ctrlfile2" ] && echo "<odoo></odoo>" > "$dest/wizard/$(basename "$ctrlfile2")"
            done
        fi

        if [ -d "$module/wizards" ]; then
            mkdir -p "$dest/wizards"
            for ctrlfile in "$module/wizards"/*.py; do
                [ -f "$ctrlfile" ] && : > "$dest/wizards/$(basename "$ctrlfile")"
            done
            for ctrlfile2 in "$module/wizards"/*.xml; do
                [ -f "$ctrlfile2" ] && echo "<odoo></odoo>" > "$dest/wizards/$(basename "$ctrlfile2")"
            done

        fi

        if [ -d "$module/reports" ]; then
            mkdir -p "$dest/reports"
            for ctrlfile in "$module/reports"/*.py; do
                [ -f "$ctrlfile" ] && : > "$dest/reports/$(basename "$ctrlfile")"
            done
            for ctrlfile2 in "$module/reports"/*.xml; do
                [ -f "$ctrlfile2" ] && echo "<odoo></odoo>" > "$dest/reports/$(basename "$ctrlfile2")"
            done
        fi

        if [ -d "$module/report" ]; then
            mkdir -p "$dest/report"
            for ctrlfile in "$module/report"/*.py; do
                [ -f "$ctrlfile" ] && : > "$dest/report/$(basename "$ctrlfile")"
            done
            for ctrlfile2 in "$module/report"/*.xml; do
                [ -f "$ctrlfile2" ] && echo "<odoo></odoo>" > "$dest/report/$(basename "$ctrlfile2")"
            done
        fi

        if [ -d "$module/module" ]; then
            mkdir -p "$dest/module"
            for ctrlfile in "$module/module"/*; do
                [ -f "$ctrlfile" ] && : > "$dest/module/$(basename "$ctrlfile")"
            done
        fi



    done
done
