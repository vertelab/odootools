#!/usr/bin/python

import sys, getopt, os
import erppeek

def usage():
    print """-h, --host=\thost
-P, --port=\tport
-d, --database=\tdatabase
-m, --module=\tcomma separated module list
-p, --password=\tadmin password
-l, --list\tlist all modules
-i, --install\tinstall modules
-u, --uninstall\tuninstall modules
"""

#TODO: add username parameter.
try:
    opts, args = getopt.getopt(sys.argv[1:], "h:P:d:m:p:liu", ["host=", "port=", "database=", "module=", "password=", "list", "install", "uninstall",])
except getopt.GetoptError as err:
    # print help information and exit:
    print str(err) # will print something like "option -a not recognized"
    usage()
    sys.exit(2)

output = None
verbose = False
HOST = os.environ.get('HOST', 'http://localhost')
PORT = os.environ.get('PORT', '8069')
DATABASE = os.environ.get('DATABASE', None)
PASSWD = os.popen('grep admin_passwd /etc/odoo/openerp-server.conf | cut -f 3 -d" "').read().replace('\n', '')
MODULE = None
LIST = None
INSTALL = None
UNINSTALL = None

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
    elif o in ("-i", "--install"):
        INSTALL = True
    elif o in ("-u", "--uninstall"):
        UNINSTALL = True
    else:
        assert False, "unhandled option"

#~ if not DATABASE:
    #~ assert False, "missing database"

#~ print 'databas: %s\tmodule: %s\tpassword: %s\tlist: %s\tinstall: %s\tuninstall: %s' %(DATABASE, MODULE, PASSWD, LIST, INSTALL, UNINSTALL)
client = erppeek.Client(HOST+':'+PORT, DATABASE, 'admin', PASSWD)
client.model('ir.module.module').update_list()
all_modules = [m['name'] for m in client.model('ir.module.module').read(client.model('ir.module.module').search((['|', ('state', '=', 'installed'), ('state', '=', 'uninstalled')])), ['name'])]
installed = [m['name'] for m in client.model('ir.module.module').read(client.model('ir.module.module').search(([('state', '=', 'installed')])), ['name'])]
to_be_installed = MODULE and MODULE.split(',') or None
to_be_upgraded = []

if LIST:
    print ','.join(installed)
elif MODULE:
    while to_be_installed:
        m = to_be_installed.pop()
        if INSTALL:
            if m in installed:
                to_be_upgraded.append(m)
            else:
                print '**** to be installed ****\n%s' %to_be_installed
                client.install(m)
                to_be_installed = list(set(to_be_installed) - set(m['name'] for m in client.model('ir.module.module').read(client.model('ir.module.module').search(([('state', '=', 'installed')])), ['name'])))
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

