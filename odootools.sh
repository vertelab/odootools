alias alldbs='`su postgres -c "psql -At -c \"select datname from pg_database where datistemplate = false and 'postgres' <> datname;\" postgres"`'
alias odoovilog='sudo vi /var/log/odoo/odoo-server.log'
alias odooadminpw='sudo grep -o "^admin_passwd.*$" /etc/odoo/odoo.conf | cut -f 3 -d" "'

alias allprojects='ls -d /usr/share/odoo-*'
alias cdo='cd /usr/share/core-odoo/addons'

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
    [ -f /etc/odoo/odoo.tools ] && . 
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
    sudo su odoo -c "odoo -c ${ODOO_SERVER_CONF} --database ${DATABASES} --init ${MODULES} --stop-after-init"
    ${ODOO_START}
}
alias odooinstall='_odoo_install_module'

function _odoo_restart() {
    [ -f /etc/odoo/odoo.tools ] && . /etc/odoo/odoo.tools
    [ -z "$ODOORESTART" ] && ODOORESTART="sudo service odoo restart"

    echo $ODOORESTART
    eval ${ODOORESTART}
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
	echo "Trying to clone from github"
        if git clone -b 17.0 git@github.com:vertelab/$PROJECT.git ; then
	    echo "Trying to clone from git.vertel.se"
	    git clone -b 17.0 git@git.vertel.se:vertelab/$PROJECT.git
	fi
    done
    cd $CWD
    sudo chown odoo:odoo /usr/share/odoo*/ -R
    sudo chmod g+w /usr/share/odoo*/ -R
}
alias odoogitclone='_odoogitclone'

function _odooaddpreprocess() {
    [ -z "$1" ] && echo "Usage: $0 odoo-x,odoo-y.." 1>&2 && return 
    [ ! -f /usr/local/bin/preprocess ] && sudo pip3 install preprocess
    [ ! -f /etc/odoo/post-checkout ] && sudo curl https://raw.githubusercontent.com/vertelab/odootools/17.0/post-checkout -o /etc/odoo/post-checkout -s
    local PROJECTS=$1
    for PROJECT in $(echo $PROJECTS | tr "," " "); do
	cp /etc/odoo/post-checkout /usr/share/$PROJECT/.git/hooks/
	chmod a+x /usr/share/$PROJECT/.git/hooks/post-checkout
    done
}
alias odooaddpreprocess='_odooaddpreprocess'



function _odoobranchget() {
	# get a module from one branch (source) to another (destination)
	usage() { echo "Usage: $0 [-p|--project <project>] [-m|--moduie <module>] [-s|--source <branch> ] [-d|--destination <branch> ]" 1>&2; exit 1; }
	[ -f /etc/odoo/odoo.tools ] && . /etc/odoo/odoo.tools
	OBRANCH=$(git rev-parse --abbrev-ref HEAD)
	DBRANCH=$OBRANCH
	export DBRANCH
	ODOOPROJECT=$(basename `git rev-parse --show-toplevel`)
	export ODOOPROJECT
	local OPTIND
	local OPTARG
	local option
	while getopts ":p:m:d:s: --long source:destination:module:project:" option; do
       		 case $option in
       		     p|project) ODOOPROJECT=${OPTARG%/} ; echo "Project: $option $ODOOPROJECT" ;;
       		     m|module) MODULE=${OPTARG} ; echo "module: $option $OPTARG" ;;
       		     s|source) SBRANCH=${OPTARG} ; echo "Source Branch: $option $OPTARG" ;;
       		     d|desitnation) DBRANCH=${OPTARG} ; echo "Destination Branch: $option $OPTARG" ;;
       		     \:) echo "Option $option requires an argument" ; return ;;
       		     \?) echo "Illegal argument ${option}::${OPTARG}" ; return ;;
       		 esac
	done
	[ -z "$ODOOPROJECT" ] && echo "You have to set -p --project option to continue" && return
	[ -z "$MODULE" ] && echo "You have to set -m --module option to continue" && return
	[ -z "$SBRANCH" ] && echo "You have to set -s --source option to continue" && return
	[ -z "$DBRANCH" ] && echo "You have to set -d --destination option to continue" && return
	[ "$DBRANCH" == "$SBRANCH" ] && echo "You have to set -d --destination option not same as -s option to continue" && return
	CWD=$(pwd)
	cd /usr/share/$ODOOPROJECT
	git checkout $SBRANCH
	files=$(find /usr/share/$ODOOPROJECT/$MODULE  \( -name "*.py" -o -name "*.js" -o -name "*.sh" -o -name "*.csv" -o -name "*.xml" \))
	git checkout $DBRANCH
	for file in $files 
	do  
		echo  ${file}
		git checkout --merge $DBRANCH $file -q

	done
	git add .
	git commit -m "odoobranchget $MODULE $SBRANCH"
	git push
	[ $OBRANCH == $(git rev-parse --abbrev-ref HEAD) ] || git checkout $OBRANCH
	cd $CWD
}
alias odoobranchget='_odoobranchget'

function _odoobranchpfile() {
	# patch p-files from source branch to all other branches that have this module
	usage() { echo "Usage: $0 [-p|--project <project>] [-m|--moduie <module>] [-s|--source <branch> ] [-d|--destination <branch> ]" 1>&2; exit 1; }
	[ -f /etc/odoo/odoo.tools ] && . /etc/odoo/odoo.tools
	OBRANCH=$(git rev-parse --abbrev-ref HEAD)
	SBRANCH=$OBRANCH
	export SBRANCH
	ODOOPROJECT=$(basename `git rev-parse --show-toplevel`)
	export ODOOPROJECT
	local OPTIND
	local OPTARG
	local option
	while getopts ":p:m:d:s: --long source:destination:module:project:" option; do
       		 case $option in
       		     p|project) ODOOPROJECT=${OPTARG%/} ; echo "Project: $option $ODOOPROJECT" ;;
       		     m|module) MODULE=${OPTARG} ; echo "module: $option $OPTARG" ;;
       		     s|source) SBRANCH=${OPTARG} ; echo "Source Branch: $option $OPTARG" ;;
       		     d|desitnation) DBRANCH=${OPTARG} ; echo "Destination Branch: $option $OPTARG" ;;
       		     \:) echo "Option $option requires an argument" ; return ;;
       		     \?) echo "Illegal argument ${option}::${OPTARG}" ; return ;;
       		 esac
	done
	[ -z "$ODOOPROJECT" ] && echo "You have to set -p --project option to continue" && return
	[ -z "$MODULE" ] && echo "You have to set -m --module option to continue" && return
	[ -z "$SBRANCH" ] && echo "You have to set -s --source option to continue" && return
	[ -z "$DBRANCH" ] && echo "You have to set -d --destination option to continue" && return
	CWD=$(pwd)
	cd /usr/share/$ODOOPROJECT
	git checkout $SBRANCH
	pfiles=`find /usr/share/$ODOOPROJECT/$MODULE \( -name "*.p.py" -o -name "*.p.js" -o -name "*.p.sh" -o -name "*.p.csv" -o -name "*.p.xml" \)`
	branches=`git branch -r | tr ' ' '\n'  | grep -E '^origin/[0-9]+\.0$' | sed 's/^origin\///'`
	for branch in $branches
	do
	   [ "$branch" == ""$SBRANCH"" ] && continue
	   echo $branch 
	   git checkout $branch
	   for file in $pfiles
	   do
	       echo $file
	       if [ -f "${file/.p/}" ]
	       then
	           git checkout --merge $SBRANCH $file -q
	       fi
	   done
	   git add .
	   git commit -m "odoobranchpfile $MODULE from $branch"
	   git push
	done
	[ $OBRANCH == $(git rev-parse --abbrev-ref HEAD) ] || git checkout $OBRANCH
	cd $CWD
}
alias odoobranchpfile='_odoobranchpfile'

function _odoobranchdiff() {
	usage() { echo "Usage: $0 [-p|--project <project>] [-m|--moduie <module>] [-s|--source <branch> ] [-d|--destination <branch> ]" 1>&2; exit 1; }
	[ -f /etc/odoo/odoo.tools ] && . /etc/odoo/odoo.tools
	OBRANCH=$(git rev-parse --abbrev-ref HEAD)
	SBRANCH=$OBRANCH
	export SBRANCH
	ODOOPROJECT=$(basename `git rev-parse --show-toplevel`)
	export ODOOPROJECT
	local OPTIND
	local OPTARG
	local option
	while getopts ":p:m:d:s: --long source:destination:module:project:" option; do
       		 case $option in
       		     p|project) ODOOPROJECT=${OPTARG%/} ; echo "Project: $option $ODOOPROJECT" ;;
       		     m|module) MODULE=${OPTARG} ; echo "module: $option $OPTARG" ;;
       		     s|source) SBRANCH=${OPTARG} ; echo "Source Branch: $option $OPTARG" ;;
       		     d|desitnation) DBRANCH=${OPTARG} ; echo "Destination Branch: $option $OPTARG" ;;
       		     \:) echo "Option $option requires an argument" ; return ;;
       		     \?) echo "Illegal argument ${option}::${OPTARG}" ; return ;;
       		 esac
	done
	[ -z "$ODOOPROJECT" ] && echo "You have to set -p --project option to continue" && return
	[ -z "$MODULE" ] && echo "You have to set -m --module option to continue" && return
	[ -z "$SBRANCH" ] && echo "You have to set -s --source option to continue" && return
	[ -z "$DBRANCH" ] && echo "You have to set -d --destination option to continue" && return
	CWD=$(pwd)
	cd /usr/share/$ODOOPROJECT
	git checkout $SBRANCH
	files=$(find /usr/share/$ODOOPROJECT/$MODULE  \( -name "*.py" -o -name "*.js" -o -name "*.sh" -o -name "*.csv" -o -name "*.xml" \))
	echo $files
	for file in $files 
	do  
		git diff --quiet $SBRANCH $DBRANCH -- $file && continue
		echo  ${file}.diff
		git diff -U10000 $SBRANCH $DBRANCH -- $file > ${file}.diff 
	done
	git checkout $OBRANCH
	cd $CWD
}
alias odoobranchdiff='_odoobranchdiff'

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
    if [ -z "$ODOOPROJECT" ] ; then
	echo "You have to set -p option to continue"
    else
	sudo chown odoo:odoo /usr/share/$ODOOPROJECT -R
	rsync -var --delete --exclude='.git/' /usr/share/$ODOOPROJECT $HOST:/usr/share
    fi
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
    ## git config

    [ -f /etc/odoo/odoo.tools ] && . /etc/odoo/odoo.tools
    if [ ! -z "$ODOOADDONS" ]; then
        CWD=`pwd`
        for p in ${ODOOADDONS//,/ }; do
            grep -q $p ~/.gitconfig
            if [ $? -ne 0 ]; then
                git config --global --add safe.directory $p
            fi
            cd $p
            echo -n $p " "
            git pull 2> ~/odoogitpull.err
        done
        cat ~/odoogitpull.err
        cd $CWD
    fi
    sudo chown odoo:odoo /usr/share/odoo*/ -R
    sudo chmod g+w /usr/share/odoo*/ -R
}
function odooextgitpull() {
    ## git config

    [ -f /etc/odoo/odoo.tools ] && . /etc/odoo/odoo.tools
    if [ ! -z "$ODOOADDONS" ]; then
        CWD=`pwd`
        for p in ${ODOOADDONS//,/ }; do
            grep -q $p ~/.gitconfig
            if [ $? -ne 0 ]; then
                git config --global --add safe.directory $p
            fi
            cd $p
            echo -n $p " "
            git pull 2> ~/odooextgitpull.err
        done
        cat ~/odooextgitpull.err
        cd $CWD
    fi
    sudo chown odoo:odoo /usr/share/odoo*/ -R
    sudo chmod g+w /usr/share/odoo*/ -R
}
function odooallrequirements() {
    for req in `ls /usr/share/odoo*/requirements.txt`
    do
        sudo pip3 install -r $req
    done
}
function odoocheckbranch() {
    ## SAVE LOCAL PATH
    OPWD=`pwd`
    for req in `ls /usr/share/odoo*/`
    do

        if [[ $req == *"/odoo"* ]]; then
            echo $req
            myPath=$req
            myCDPath=${myPath::-2}
            echo $myCDPath
            cd $myCDPath
            git branch
            if [[ `git branch` == *"17"* ]]; then 
                echo "17!!!"
            else
                git checkout 17.0
            fi
        fi
    done
    ## RESTORE LOCAL PATH
    cd $OPWD
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
    if [ ! -z "$ODOOADDONS" ]; then
        for p in ${ODOOADDONS//,/ }; do
            echo -n $p " "
            sudo chown odoo:odoo $p -R
            find $p -type d -exec sudo chmod 775 {} \;
            find $p -type f -exec sudo chmod 664 {} \;
        done

        sudo chown odoo:odoo /usr/share/core-odoo -R
        sudo chown odoo:odoo /usr/share/odoo-addons -R
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
    echo "odoo --modules='${MODULES}' -d ${DATABASES} ${LCMD} --stop-after-init --i18n-export='${FILE}'"
    sudo su odoo -c "odoo -c /etc/odoo/odoo.conf --modules='${MODULES}' -d ${DATABASES} ${LCMD} --stop-after-init --i18n-export='${FILE}'"
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

# 1) tar är mer unix-mässigt än zip som dessutom måste installeras på de flesta maskiner
# 2) /etc/odoo är ett bättre ställe för scaffold.tgz
# 3) Vår standard är -p för project som dessutom skall läggas in i environment ODOOPROJECT -p skall kunna utelämnas och då är det ODOOPROJECT som gäller se cdp
# 4) -m kan vara lämpligt för modul
# 5) försök att inte behöva mellanlagra data i onödan på filsystemet, kommandot bör vara oberoende av var man står i filsystemet och får inte heller förflytta användaren
# Överfört till kod skulle det kunna se ut så här:
function _odoo_scaffold() {
    usage() { echo "Usage: $0 [-p <project>] [-m <module>]" 1>&2; exit 1; }
    [ -f /etc/odoo/odoo.tools ] && . /etc/odoo/odoo.tools
    local OPTIND
    local OPTARG
	local PROJECT
    local option
    while getopts ":p:m:" option; do
        case $option in
            p) PROJECT=${OPTARG%/} ; echo "Project: $option $PROJECT" ;;
            m) MODULE=${OPTARG} ; echo "Module: $option $OPTARG" ;;
            \:) echo "Option $option requires an argument" ; return ;;
            \?) echo "Illegal argument ${option}::${OPTARG}" ; return ;;
        esac
    done
	if [ ! -d "/usr/share/$PROJECT" ] ; then
		sudo mkdir /usr/share/$PROJECT
		sudo chown odoo:odoo /usr/share/$PROJECT
		echo "Project successfully created!"
	fi
    if [ -z "$PROJECT" ] ; then
        echo "You have to set -p option to continue"
    elif [ -d "/usr/share/$PROJECT/$MODULE" ] ; then
        echo "Module already exists at path: (/user/share/$PROJECT/$MODULE)"
    elif [ -z "$MODULE" ] ; then
        echo "You have to set -m option to continue"
    else
        sudo mkdir /usr/share/$PROJECT/$MODULE
        sudo tar xvf /etc/odoo/scaffold.tar.gz -C /usr/share/$PROJECT/$MODULE
        sudo chown odoo:odoo /usr/share/$PROJECT/$MODULE
    fi
}
alias odooscaffold='_odoo_scaffold'

# Opens psql interface
# Usage: 'odoopsql <database>'
function _odoopsql() {
    [ ! -z "$1" ] && sudo su odoo -c "psql $1"
    [ -z "$1" ] && echo "Usage: odoopsql databasename"
}
alias odoopsql="_odoopsql"

# Finds installed modules in given database
# Usage: 'odoomodules <database>'
function _odoomodules() {
    [ ! -z "$1" ] && sudo su odoo -c "psql $1 -c \"select name from ir_module_module where state='installed' order by name asc\"" | tail -n +3 | head -n -2 | sed 's/^ //g' | less
    [ -z "$1" ] && echo "Usage: odoomodules databasename"
}
alias odoomodules="_odoomodules"

alias odoocheckdeps='python3 /usr/local/bin/odoocheckdeps.py'
