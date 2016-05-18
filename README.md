# odootools


Install by:


wget -O- https://raw.githubusercontent.com/vertelab/odootools/master/install | bash


Uninstall by: (this drops your databases and all your data related to Odoo)

wget -O- https://raw.githubusercontent.com/vertelab/odootools/master/uninstall | bash


Odoo-tools commands:

Odoo-tools command |Description
--- | --- 
 alldbs                    | Lists all databases             
 allprojects               | Lists all projects              
 cdb                       | change database                 
 cdo                       | change directory to Odoo core   
 cdp                       | change directory to project     
 odooaddons                | Updates addons_path with all project according to ODOOADDONS defined in odoo.tools  sasd asd asdas asd asd asd asd asd asd asd as das d asd asd sdasd asd asd asd         
 odooadminpw               | view master password            
 odoofind <pattern>        | find patterns in odoo-core source code                     
 odoogitclone <project>    | clones and installs projects from githuh (vertel-projects)   
 odoopatch                 | Implements patches from the dir-
                           | ectory /etc/odoo/patch.p        
 odoorestart               | Restarts odoo and apache/varnish 
 odoosync -h <host> -p <project> | Syncs a project to a server      
               | without git meta data           
 odootail                  | Views odoo-log live, you can use
                           | the one-liner                   
                           | odoorestart ; odootail          
                           | to restart and monitor odoo     
|odooupd                   | Modifies Odoo-instanses  -h, --host=	host 
-P, --port=	port               
-d, --database=	database       |
                           |  -m, --module=	comma separated
                           |                  module list    
                           |  -p, --password=	admin password 
                           |  -l, --list	list all modules   
                           |  -i, --install	install modules
                           |  -u, --uninstall	uninstall      
                           |                         modules 
 odooupdm <database>       | Installs/updates modules in     
          <modulelist>     | single user mode                
 odoovilog                 | Opens Odoo log file in vi       
 
