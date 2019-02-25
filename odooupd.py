#!/usr/bin/python

import sys, getopt, os, subprocess
import erppeek
from openerp.modules import get_module_path


def usage():
    print """-h, --host=\thost
-P, --port=\tport
-d, --database=\tdatabase
-c, --check=\tcomma separated module list to check
-m, --module=\tcomma separated module list
-p, --password=\tadmin password
-l, --list\tlist all modules
-L, --listprojects\tlist all projects
-i, --install\tinstall modules
-u, --uninstall\tuninstall modules
-U, --update_list\tupdate_list of modules


"""
#~ def get_projects(modules):
        #~ module_path = set()
        #~ for m in modules
        #~ if m.index('/') and get_module_path(m).split('/')[-2] not in module_path:
            #~ module_path.add(get_module_path(m).split('/')[-2])
        #~ return module_path


def get_module_name(domain):
    return client.model('ir.module.module').read(client.model('ir.module.module').search((domain)), ['name'])

try:
    opts, args = getopt.getopt(sys.argv[1:], "h:P:d:m:p:lLiuUc:", ["host=", "port=", "database=", "module=", "password=", "list", "install", "uninstall", "update_list", "check="])
except getopt.GetoptError as err:
    # print help information and exit:
    print str(err) # will print something like "option -a not recognized"
    usage()
    sys.exit(2)

output = None
verbose = False
#~ HOST = os.environ.get('HOST', 'localhost')
HOST = os.environ.get('HOST', 'http://localhost')
PORT = os.environ.get('PORT', '8069')
DATABASE = os.environ.get('DATABASE', None)
PASSWD = os.popen('sudo grep admin_passwd /etc/odoo/openerp-server.conf | cut -f 3 -d" "').read().replace('\n', '')
MODULE = None
LIST = None
LISTP = None
INSTALL = None
UNINSTALL = None
UPDATE_LIST = None
CHECK = None

for o, a in opts:
    if o == "-v":
        verbose = True
    elif o in ("-h", "--host"):
        HOST = a
        #~ usage()
        #~ sys.exit()
    elif o in ("-P", "--port"):
        PORT = a
    elif o in ("-d", "--database"):
        DATABASE = a
    elif o in ("-m", "--module"):
        MODULE = a
    elif o in ("-p", "--password"):
        PASSWD = a
    elif o in ("-l", "--list"):
        LIST = True
    elif o in ("-L", "--listprojects"):
        LISTP = True
    elif o in ("-i", "--install"):
        INSTALL = True
    elif o in ("-u", "--uninstall"):
        UNINSTALL = True
    elif o in ("-U", "--update_list"):
        UPDATE_LIST = True
    elif o in ("-c", "--check"):
        CHECK = a
    else:
        assert False, "unhandled option"

#~ if not DATABASE:
    #~ assert False, "missing database"

#~ print 'host: %s:%s\tdatabas: %s\tmodule: %s\tpassword: %s\tlist: %s\tlistp: %s\tinstall: %s\tuninstall: %s' %(HOST, PORT,DATABASE, MODULE, PASSWD, LIST, LISTP, INSTALL, UNINSTALL)
#~ odoo = odoorpc.ODOO(HOST, port=PORT)
#~ odoo.login(DATABASE, 'admin', PASSWD)
client = erppeek.Client(HOST+':'+PORT, DATABASE, 'admin', PASSWD)
if UPDATE_LIST:
    client.model('ir.module.module').update_list()
if LIST:
    installed = [m['name'] for m in get_module_name([('state', '=', 'installed')])]
    print ','.join(installed)
elif LISTP:
    module_path = {}
    missing = []
    for module in [m['name'] for m in get_module_name([('state', '=', 'installed')])]:
        path = subprocess.Popen('locate %s/__openerp__.py' % module,shell=True,stdout=subprocess.PIPE ).stdout.readlines()
        if path:
            path = path[-1].strip()
            if path.split('/')[-3] in module_path:
                module_path[path.split('/')[-3]].append(module)
            else:
                module_path[path.split('/')[-3]] = [module]
        else:
            if module_path.get('missing'):
                module_path['missing'].append(module)
            else:
                module_path['missing'] = [module]
    for p in module_path.keys():
        print p,':',','.join(module_path[p])
    
elif CHECK:
    sys.exit(len(client.model('ir.module.module').search([('state', '=', 'installed'), ('name', '=', CHECK)])) == 0)
elif MODULE:
    all_modules = [m['name'] for m in get_module_name(['|', ('state', '=', 'installed'), ('state', '=', 'uninstalled')])]
    installed = [m['name'] for m in get_module_name([('state', '=', 'installed')])]
    to_be_installed = MODULE and MODULE.split(',') or None
    to_be_upgraded = []
    while to_be_installed:
        m = to_be_installed.pop()
        if INSTALL:
            if m in installed:
                to_be_upgraded.append(m)
            else:
                print '**** to be installed ****\n%s' %to_be_installed
                client.install(m)
                to_be_installed = list(set(to_be_installed) - set(m['name'] for m in get_module_name([('state', '=', 'installed')])))
        if UNINSTALL:
            if m in installed:
                client.uninstall(m)
    for m in to_be_upgraded:
        client.upgrade(m)


else:
    print 'Nothing to do'


#~ if sys.argv[1] == 'list_modules':
    #~ DATABASE =  sys.argv[2]
    #~ USERNAME =  sys.argv[3]
    #~ PASSWORD =  sys.argv[4]
    #~ client = erppeek.Client('http://localhost:8069', DATABASE, USERNAME, PASSWORD)
    #~ proxy = client.model('ir.module.module')
    #~ installed_modules = proxy.browse([('state', '=', 'installed')])
    #~ for module in installed_modules:
        #~ print(module.name)



#~ elif sys.argv[1] == 'install_module':
    #~ DATABASE =  sys.argv[2]
    #~ USERNAME =  sys.argv[3]
    #~ PASSWORD =  sys.argv[4]
    #~ MODULE =  sys.argv[5]
    #~ client = erppeek.Client('http://localhost:8069', DATABASE, USERNAME, PASSWORD)
    #~ modules = client.modules(MODULE, installed=False)
    #~ if MODULE in modules['uninstalled']:
        #~ client.install(MODULE)
        #~ print('The module %s has been installed!' %MODULE)

#~ elif sys.argv[1] == 'update_module':
    #~ DATABASE =  sys.argv[2]
    #~ USERNAME =  sys.argv[3]
    #~ PASSWORD =  sys.argv[4]
    #~ MODULE =  sys.argv[5]
    #~ client = erppeek.Client('http://localhost:8069', DATABASE, USERNAME, PASSWORD)
    #~ modules = client.modules(MODULE, installed=True)

    #~ if MODULE in modules['installed']:
        #~ client.upgrade(MODULE)
        #~ print('The module %s has been upgraded!' %MODULE)

#~ elif sys.argv[1] == 'uninstall_module':
    #~ DATABASE =  sys.argv[2]
    #~ USERNAME =  sys.argv[3]
    #~ PASSWORD =  sys.argv[4]
    #~ MODULE =  sys.argv[5]
    #~ client = erppeek.Client('http://localhost:8069', DATABASE, USERNAME, PASSWORD)
    #~ modules = client.modules(MODULE, installed=True)

    #~ if MODULE in modules['installed']:
        #~ client.uninstall(MODULE)
        #~ print('The module %s has been uninstalled!' %MODULE)

#~ elif sys.argv[1] == 'create_database':
    #~ DATABASE =  sys.argv[2]
    #~ PASSWORD =  sys.argv[3]
    #~ print(DATABASE + ' : ' + ADMIN_PASSWORD)
    #~ SERVER = 'http://localhost:8069'
    #~ client = erppeek.Client(server=SERVER)
    #~ if not DATABASE in client.db.list():
        #~ print("The database does not exist yet, creating one!")
        #~ client.create_database(ADMIN_PASSWORD, DATABASE)
    #~ else:
        #~ print("The database " + DATABASE + " already exists.")

#~ else:
    #~ print('Unknown command!')

