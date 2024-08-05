#!/usr/bin/bash

ODOO_CONFIGURATION_FILE='/etc/odoo/odoo.conf'
OCB_DIRECTORY='/usr/src/OCB'
VERSION=$1
YESNO=$2

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
NOCOLOR='\033[0m'

echo check if pip is installed for root
if [[ -z "$(sudo which pip)" ]]; then
    echo installing pip for root
    wget -O- https://bootstrap.pypa.io/get-pip.py | sudo python3
fi

# echo installing pip for $USER
# wget -O- https://bootstrap.pypa.io/get-pip.py | python3

if [ -n "$(pip freeze | grep odoo)" ]; then

    if [ -z "${VERSION}" ]; then

        VERSION_INFO=$(sudo cat /usr/share/core-odoo/release.py | grep "version_info =")

        VERSION=python3 -c "${test/FINAL/\'\'}[:2] ; print('.'.join(map(lambda x: str(x),version_info))) ;"

    fi

    while true; do

    if [ -z "${YESNO}" ]; then

        read -p "odoo is already installed do you want to uninstall odoo? (y/n) " YESNO

    fi

    case $YESNO in 
        [yY] ) echo uninstalling odoo...;
            sudo apt remove --purge odoo
            sudo pip uninstall odoo --root-user-action=ignore
            break;;
        [nN] )
            break;;
        * ) echo invalid response;;
    esac

    done

fi

if [ -d $OCB_DIRECTORY ]; then

    sudo git -C $OCB_DIRECTORY pull

elif [ ! -d $OCB_DIRECTORY ]; then

    sudo git clone --depth=1 --single-branch --branch $VERSION https://github.com/OCA/OCB.git $OCB_DIRECTORY

fi

echo installing dependencies
sudo apt install -y build-essential libsasl2-dev python-dev-is-python3 libldap2-dev libssl-dev libpq-dev

echo installing PostgreSQL
sudo apt install -y postgresql postgresql-client

sudo pip install -r /usr/src/OCB/requirements.txt --root-user-action=ignore

echo adding odoo-bin 
sudo cp /usr/src/OCB/odoo-bin /usr/bin/odoo
echo adding odoo.service
sudo cp /usr/src/OCB/debian/odoo.service /usr/lib/systemd/system/odoo.service
echo adding odoo daemon
sudo cp /usr/src/OCB/debian/init /etc/init.d/odoo

echo creating /etc/odoo
if [ ! -d /etc/odoo ]; then
    sudo mkdir /etc/odoo
fi
sudo cp /usr/src/OCB/debian/odoo.conf /etc/odoo/odoo.conf

echo creating odoo user
sudo su -c "bash /usr/src/OCB/debian/postinst configure"

echo adding odoo as a python library
sudo pip install -U git+https://github.com/OCA/OCB.git@$VERSION 

ADDONS_PATH=$(sudo grep "addons_path" $ODOO_CONFIGURATION_FILE)
sudo sed -i "s:$ADDONS_PATH:addons_path=/usr/src/OCB/addons:" $ODOO_CONFIGURATION_FILE

sudo systemctl daemon-reload

if [[ "$(sudo systemctl is-active odoo)" != "active" ]]; then
    sudo systemctl restart odoo
fi

if [[ "$(sudo systemctl is-active odoo)" == "inactive" ]]; then
    echo -e "${RED}odoo is not starting!!! check the logs at /var/log/odoo/odoo-server.log to figure out why ${NOCOLOR}" 

elif [[ "$(sudo systemctl is-active odoo)" == "active" ]]; then
    echo -e "${GREEN}odoo started successfully ${NOCOLOR}" 

else
    echo -e "${RED}Something seems to have gone horribly wrong!!! ${NOCOLOR}" 
fi

