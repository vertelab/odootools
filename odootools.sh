alias alldbs='`su postgres -c "psql -At -c \"select datname from pg_database where datistemplate = false and 'postgres' <> datname;\" postgres"`'
alias odoovilog='sudo vi /var/log/odoo/odoo-server.log'
alias odooadminpw='sudo grep admin_passwd /etc/odoo/odoo.conf | cut -f 3 -d" "'

alias allprojects='ls -d /usr/share/odoo-*'
alias cdo='cd /usr/share/odoo-addons'

export ODOO_USER="odoo"
export ODOO_SOURCE_DIR=/opt/odoo
export ODOO_SERVER_CONF=/etc/odoo/odoo.conf
export LOGS_DIR=/var/log/odoo

export DISTRO='ubuntu'
[ -z `grep -o 'redhat.com' /proc/version` ] || export DISTRO='redhat'
[ -z `grep -o 'centos.org' /proc/version` ] || export DISTRO='centos'
export ODOO_SERVER='odoo'
[ $DISTRO == 'redhat' -o $DISTRO == 'centos' ] && export ODOO_SERVER='/opt/odoo/odoosrc/odoo-bin'
export ODOO_START='sudo service odoo start'
[ $DISTRO == 'redhat' -o $DISTRO == 'centos' ] && export ODOO_START='sudo systemctl start odoo'
export ODOO_STOP='sudo service odoo stop'
[ $DISTRO == 'redhat' -o $DISTRO == 'centos' ] && export ODOO_STOP='sudo systemctl stop odoo'

function odootail() {
    tail -f /var/log/odoo/odoo-server.log | awk ' {
      gsub("INFO", "\033[0;32mINFO\033[0m", $0); 
      gsub("WARNING", "\033[0;33mWARNING\033[0m", $0);
      gsub("ERROR", "\033[0;31mERROR\033[0m", $0);
      print $0 };
      '
}

function _cdprojectdir() {
    [ -z $1 ] || ODOOPROJECT=$1
    cd /usr/share/$ODOOPROJECT
}
alias cdp='_cdprojectdir'

function _cddatabase() {
    [ -z $1 ] || DATABASES=$1
}
alias cdb='_cddatabase'

function _dirname() {
    DIR=`dirname $1`
    BASE=`basename $DIR`
    echo -n $BASE + ","
}

function _odoo_update_module() {
    ${ODOO_STOP}
    sudo su odoo -c "odoo -c ${ODOO_SERVER_CONF} --database $1 --update $2 --stop-after-init"
    ${ODOO_START}
}
alias odooupdm='_odoo_update_module'

function _odoo_install_module() {
    usage() { echo "Usage: $0 [-d <database>] [-m <module>]" 1>&2; exit 1; }
    [ -f /etc/odoo/odoo.tools ] && . /etc/odoo/odoo.tools
    local OPTIND  # To force the while getops loop
    local OPTARG
    local option
    while getopts ":m:d:" option; do
        case "${option}" in
            d|db) DATABASES=${OPTARG} ; echo "DB: $option $OPTARG" ;;
            m|module) MODULES=${OPTARG} ;;
            \:) echo "Option $option requires an argument" ; return ;;
            \?) echo "Illegal argument ${option}::${OPTARG}" ; return ;;
        esac
    done
    echo "For databases=${DATABASES} modules=${MODULES}"

    ${ODOO_STOP}
    sudo su odoo -c "odoo.py -c ${ODOO_SERVER_CONF} --database ${DATABASES} --init ${MODULES} --stop-after-init"
    ${ODOO_START}
}
alias odooinstall='_odoo_install_module'

function _odoo_restart() {
    [ -f /etc/odoo/odoo.tools ] && . /etc/odoo/odoo.tools
    [ -z "$ODOORESTART" ] && ODOORESTART="sudo service odoo restart"
    
    echo $ODOORESTART
    ${ODOORESTART}
}
alias odoorestart='_odoo_restart'

function _odoofind() {
    find -L /usr/share/odoo-addons -type f -exec grep -Hn $1 {} \;
}
alias odoofind='_odoofind'

function _odoolistprojects() {
    local PROJECTS=""
    for PROJECT in $(ls /usr/share/odoo-* | grep -v odoo-addons); do
        PROJECTS+=$PROJECT,
    done
    echo "${PROJECTS::-1}"
}
alias odoolistprojects='_odoolistprojects'

function _odoogitclone() {
    CWD=$(pwd)
    cd /usr/share
    local PROJECTS=$1
    for PROJECT in $(echo $PROJECTS | tr "," " "); do
        sudo mkdir -p --mode=g+w /usr/share/$PROJECT
        sudo chown odoo:odoo /usr/share/$PROJECT
        git clone -b 13.0 git@github.com:vertelab/$PROJECT.git
    done
    cd $CWD
}
alias odoogitclone='_odoogitclone'

function _odoosync() {
    usage() { echo "Usage: $0 [-p <project>] [-h <host>]" 1>&2; exit 1; }
    [ -f /etc/odoo/odoo.tools ] && . /etc/odoo/odoo.tools
    local OPTIND
    local OPTARG
    local option
    while getopts ":p:h:" option; do
        case $option in
            p) ODOOPROJECT=${OPTARG%/} ; echo "Project: $option $ODOOPROJECT" ;;
            h) HOST=${OPTARG} ; echo "Host: $option $OPTARG" ;;
            \:) echo "Option $option requires an argument" ; return ;;
            \?) echo "Illegal argument ${option}::${OPTARG}" ; return ;;
        esac
    done
    sudo chown odoo:odoo /usr/share/$ODOOPROJECT -R
    rsync -var --delete --exclude='.git/' /usr/share/$ODOOPROJECT $HOST:/usr/share
}
alias odoosync='_odoosync'

function _patch_all_patches() {
    CWD=`pwd`
    cd /usr/lib/python3/dist-packages/odoo
    for PATCH in /etc/odoo/patch.d/*.patch; do
        sudo patch -p6 < $PATCH
    done
    cd $CWD
}
alias odoopatch='_patch_all_patches'

function odooaddons() {
    [ -f /etc/odoo/odoo.tools ] && . /etc/odoo/odoo.tools
    if [ ! -z "$ODOOADDONS" ]; then
        CMD="s/^addons_path.*=.*/addons_path=${ODOOADDONS//"/"/"\/"}/g"
        sudo perl -i -pe $CMD $ODOO_SERVER_CONF
    fi
}

function odoogitpull() {
    [ -f /etc/odoo/odoo.tools ] && . /etc/odoo/odoo.tools
    if [ ! -z "$ODOOADDONS" ]; then
        CWD=`pwd`
        for p in ${ODOOADDONS//,/ }; do
            cd $p
            echo -n $p " "
            git pull 2> ~/odoogitpull.err
        done
        cat ~/odoogitpull.err
        cd $CWD
    fi
}
function odoosyncall() {
    usage() { echo "Usage: $0 [-h <host>]" 1>&2; exit 1; }
    [ -f /etc/odoo/odoo.tools ] && . /etc/odoo/odoo.tools
    local OPTIND
    local OPTARG
    local option
    while getopts ":h:" option; do
        case $option in
            h) HOST=${OPTARG} ; echo "Host: $option $OPTARG" ;;
            \:) echo "Option $option requires an argument" ; return ;;
            \?) echo "Illegal argument ${option}::${OPTARG}" ; return ;;
        esac
    done
    if [ ! -z "$ODOOADDONS" ]; then
        for p in ${ODOOADDONS//,/ }; do
            echo -n $p " "
            sudo chown odoo:odoo $p -R
            rsync -ar --delete --exclude='.git/' $p $HOST:/usr/share
        done
    fi
}

function odoosetperm() {
    if [ ! -z "$ODOOADDONS" ]
    then
        for p in ${ODOOADDONS//,/ }; do
            echo -n $p " "
            sudo chown odoo:odoo $p -R
            find $p -type d -exec sudo chmod 775 {} \;
            find $p -type f -exec sudo chmod 665 {} \;
        done
    fi
}

function odoolangexport() {
    usage() { echo "Usage: $0 [-d <database>] [-m <module>] [-l <language>]" 1>&2; exit 1; }
    [ -f /etc/odoo/odoo.tools ] && . /etc/odoo/odoo.tools
    local OPTIND  # To force the while getops loop
    local OPTARG
    local option
    local L
    while getopts ":m:d:l:" option; do
        case "${option}" in
            d|db) DATABASES=${OPTARG} ; echo "DB: $option $OPTARG" ;;
            m|module) MODULES=${OPTARG} ;;
            l|language) L=${OPTARG} ;;
            \:) echo "Option $option requires an argument" ; return ;;
            \?) echo "Illegal argument ${option}::${OPTARG}" ; return ;;
        esac
    done
    echo "For databases=${DATABASES} modules=${MODULES} language=${L}"
    if [ ! -z "${L}" ]
    then
        LCMD="-l ${L}"
        FILE="${L}.po"
    else
        LCMD="-l ''"
        FILE="${MODULES}.po"
    fi
    echo $FILE
    sudo service odoo stop
    echo "odoo.py --modules='${MODULES}' -d ${DATABASES} ${LCMD} --stop-after-init --i18n-export='${FILE}'"
    sudo su odoo -c "odoo.py -c /etc/odoo/odoo.conf --modules='${MODULES}' -d ${DATABASES} ${LCMD} --stop-after-init --i18n-export='${FILE}'"
    sudo service odoo start
    sudo chown ${USER} ${FILE}
    if [ -z "${L}" ]
    then
        mv ${FILE} ${FILE}t
    fi
}

function _create_test_db() {
    if [ -z ${1} ];then
        echo "Usage: odoocreatetestdb <database name> <input file or stdin>"
        return
    fi
    sudo service odoo stop
    if sudo -u odoo psql -lqt| cut -d \| -f 1|grep -qw $1; then
        echo "Database "$1" already exists!"
        return
    fi
    sudo -u odoo createdb $1
    zcat "${2:-/dev/stdin}" | sudo -u odoo psql $1
    sudo -u odoo psql $1 -c "update fetchmail_server set active = false;"
    sudo -u odoo psql $1 -c "update ir_mail_server set active = false;"
    sudo service odoo start
    sleep 1
    odooupd -d $1 -i -m web_environment_ribbon
}
alias odoocreatetestdb='_create_test_db'

function _odoocheckmodule() {
    for DB in `sudo su postgres -c "psql -At -c \"select datname from pg_database where datistemplate = false and 'postgres' <> datname;\" postgres"`
    do
        if odooupd -d $DB -c $1; then
            echo $DB
        fi
    done
}
alias odoocheckmodule='_odoocheckmodule'
