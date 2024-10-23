#!/bin/bash

for module in `ls -d "$@"`
do
    [ -f $module/i18n/sv.po ] && ./tr.sh $module/i18n/sv.po
done
