# odootools

Install by:

 wget -O- https://raw.githubusercontent.com/vertelab/odootools/10.0/install | bash

Uninstall by: (this drops your databases and all your data related to Odoo)

wget -O- https://raw.githubusercontent.com/vertelab/odootools/10.0/uninstall | bash


<b>ProgrammingError: permission denied to create database</b> <br>
This install will generate an error. Here is the solution:
- Install two times.
- "ProgrammingError: permission denied to create database" <br>
sudo su postgres<br>
psql<br>
ALTER USER odoo WITH CREATEDB;<br>
Try to create the db once again<br>
<br>
See URL: https://www.odoo.com/forum/help-1/programmingerror-permission-denied-to-create-database-64086


Odoo-tools commands:

Odoo-tools command |Description
--- | --- 
 alldbs                    | Lists all databases             
 allprojects               | Lists all projects              
 cdb                       | change database                 
 cdo                       | change directory to Odoo core   
 cdp                       | change directory to project     
 odooaddons                | Updates addons_path with all project according to ODOOADDONS defined in odoo.tools
 odooadminpw               | view master password            
 odoofind *pattern*        | find patterns in odoo-core source code                     
 odoogitclone *project*    | clones and installs projects from githuh (vertel-projects)   
 odoogitpull    | does a *git pull* for every project in ODOOADDONS  
 odoolangexport    | export po/pot file for a module, -m <module> -d <database> -l <language>. To export a pot-file exclude "-l"
 odoopatch                 | Implements patches from the directory /etc/odoo/patch.d        
 odoorestart               | Restarts odoo and apache/varnish or other systems that have to be restarted (configure in odoo.tools)
 odoosetperm               | Sets permissions for all projects and modules
 odoosyncall -h *host*     | Syncs all projects and modules
 odoosync -h *host* -p *project* | Syncs a project to a server without git meta data           
 odootail                  | Views odoo-log live, you can use the one-liner *odoorestart ; odootail* to restart and monitor odoo
odooupd -h/--host, -P/--port, -d/--database, -m/--module, -p/--password, -l/--list, -i/--install, -u/--uninstall | Modifies Odoo-instanses; -m/--module=	comma separated  module list, -i/--install	install or upgrade modules  -u, --uninstall	uninstall modules
odooupdm *database* *modulelist*      | Installs/updates modules in single user mode                
 odoovilog                 | Opens Odoo log file in vi       
 
