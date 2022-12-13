# odootools for Ubuntu 20.04

Tools to help to install and manage an Odoo installation.

## Prerequisites

The installation scripts assume the host OS is Ubuntu 20.04. Usage on other
systems might require tweaking to work.

Odoo 14 require `init-system-helpers 1.57` or later. This rules out usage of
Ubuntu 18.04 or older.

## Install

Installation of Odoo and Odootools.

Ensure you are using the version (eg branch 14.0 for Odoo 14) you want to install.

When you are logged in with the root-account. Run the following command.

Step 1: The command below will download and execute the installation script:
```
wget -O- https://raw.githubusercontent.com/vertelab/odootools/14.0/install | bash
```

Step 2: Add users with these commands:
Add userser
```
sudo adduser $USER
sudo adduser $USER sudo
sudo adduser $USER odoo

Access denied! FATAL: role "odoo" does not exist 
https://www.cier.tech/blog/odoo-tutorials-1/post/operationalerror-fatal-role-odoo-does-not-exist-65

Simply copy and paste this in your terminal:
1) sudo su postgres
2) createuser odoo -s
3) psql template1
4) \q
5) exit

```
Step 3: Follow the instructions for the management of the Odoo source repositories
https://github.com/vertelab/odootools/blob/14.0/repos/README.md

Step 4: If you want to add more than the standard themes please add them from here
https://github.com/vertelab/odootools/blob/14.0/themes

## Upgrade

If you are developing new features for odoo tools bash scripts and need to verify your changes
or test them, please move them to the profile.d folder and verify their functionality.

```
cp odootools.sh /etc/profile.d/
cp odooscaffold.tar.gz /etc/odoo/
```

then restart the bash instance, make sure your changes are working correctly, before pushing the changes.


## Uninstall

Use the command below to uninstall your Odoo installation.

*this drops your databases and all your data related to Odoo*
```
wget -O- https://raw.githubusercontent.com/vertelab/odootools/14.0/uninstall | bash
```


## Odoo-tools commands

Odoo-tools command |Description
--- | ---
 alldbs                    | Lists all databases
 allprojects               | Lists all projects
 cdb                       | change database
 cdo                       | Shortcut: /usr/share/core-odoo/addons$
 cdp                       | Shortcut: /usr/share$
 odooaddons                | Updates the addons_path with all project according to ODOOADDONS defined in odoo.tools. These are stored here: https://github.com/vertelab/odootools/blob/14.0/repos/
 odooadminpw               | view master password
 odooallrequirements       | Loop through all projects installing / updating requirements.txt
 odoocheckmodule   <module>        | lists databases that use a module (eg odoocheckmodule sale)
 odoocheckdeps             | Helper script that is primarally intended to find missing dependencies. Can easily be extended to also show dependencies/consequences
 odoocreatetestdb <database name> <input file or stdin> | Creates new database without e-mail-settings for outgoing mail
 odoofind *pattern*        | find patterns in odoo-core source code
 odoogitclone *project*    | clones and installs projects from githuh (vertel-projects)
 odoogitpull    | does a *git pull* for every project in ODOOADDONS
 [odoolangexport](https://github.com/vertelab/odootools/blob/14.0/odoolangexport.pdf)    | export po/pot file for a module, -m <module> -d <database> -l <language>. To export a pot-file exclude "-l"
 odoomodules <database>    | List all installed modules in a database
 odoopsql <database>       | Open database in psql-mode
 odoopatch                 | Implements patches from the directory /etc/odoo/patch.d
 odoorestart               | Restarts odoo and apache/varnish or other systems that have to be restarted (configure in odoo.tools)
 odoosetperm               | Sets permissions for all projects and modules
 odoosyncall -h *host*     | Syncs all projects and modules
 odoosync -h *host* -p *project* | Syncs a project to a server without git meta data
 odooscaffold -p *project* -m *modulename* | Creates a boilerplate for new modules to work from
 odootail                  | Views odoo-log live, you can use the one-liner *odoorestart ; odootail* to restart and monitor odoo
odooupd -h/--host, -P/--port, -d/--database, -m/--module, -p/--password, -l/--list, -i/--install, -u/--uninstall | Modifies Odoo-instanses; -m/--module=	comma separated  module list, -i/--install	install or upgrade modules  -u, --uninstall	uninstall modules, -c/--check coma separeted module list
odooupdm *database* *modulelist*      | Installs/updates modules in single user mode. For example: $ odooupdm customer_db1 base
 odoovilog                 | Opens Odoo log file in vi


 ## /etc/odoo/odoo.tools
 You can change the line
 ```
 export ODOOHOSTS=""
 ```
 to change the autocomplete for odootools commands that has a target host.

Type this command
 ```
user@odoo14server:~/odootools$ . odootools.sh
 ```
to load new or update current odootools commands to the Terminal.

