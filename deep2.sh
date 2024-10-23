#!/bin/bash

for module in `ls -d "$@"`
do
    [ -f $module/i18n/sv.po ] && python3 ./deepltrans.py -l sv -f $module/i18n/sv.po
done
