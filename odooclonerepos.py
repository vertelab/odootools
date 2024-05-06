#!/bin/python3
import re
from github import Github, Auth
import requests

import sys, getopt, os


def usage():
    print("""-r, --repo=\t<repo>-repo get repo
-b, --branch=\tbransch use this branch
-l, --list=\tlist all repos
-a, --all\tget all repos 
""")



GITHUB_BASE_URL = 'https://api.github.com'
GITHUB_RAW_URL = 'https://raw.githubusercontent.com'



if not os.access('/etc/odoo/github_auth',os.F_OK):
    print(f"ERROR we need a file called /etc/odoo/github_auth. Create token in github. To do that go into settings and after that developer settings. Copy the token into github_auth")
    exit(2)

file = open("/etc/odoo/github_auth")
content = file.readlines()
print(content[0].strip())

auth = Auth.Token(content[0].strip())
g = Github(auth=auth)

try:
    opts, args = getopt.getopt(sys.argv[1:], "r:b:la", ["repo=", "branch=", "list", "all",])
except getopt.GetoptError as err:
    # print help information and exit:
    print(str(err)) # will print something like "option -a not recognized"
    usage()
    sys.exit(2)

output = None
verbose = False
BRANCH = os.environ.get('BRANCH', '17.0')
REPO = None
LIST = None
ALL = None

for o, a in opts:
    if o == "-l":
        LIST = True
    elif o in ("-r", "--repo"):
        REPO = a
        #~ usage()
        #~ sys.exit()
    elif o in ("-b", "--branch"):
        BRANCH = a
    elif o in ("-a", "--all"):
        ALL = True
    else:
        assert False, "unhandled option"

#~ if not DATABASE:
    #~ assert False, "missing database"

#~ print 'host: %s\tdatabas: %s\tmodule: %s\tpassword: %s\tlist: %s\tinstall: %s\tuninstall: %s' %(HOST, DATABASE, MODULE, PASSWD, LIST, INSTALL, UNINSTALL)

GITHUB_BASE_URL = 'https://api.github.com'
GITHUB_RAW_URL = 'https://raw.githubusercontent.com'

# ~ branches = [b.name for b in repo.get_branches() if re.match("^\d*[.]0$", b.name)]


def clone_repo(repo,branch):
    

    if os.access('/usr/share',os.F_OK):
        if not os.access('/usr/share',os.W_OK):
            print(f"ERROR does not have write rights on /usr/share")
            exit(2)
    else:
        print(f"ERROR missing /usr/share")
        exit(2)
    # ~ https://raw.githubusercontent.com/vertelab/odootools/16.0/repos/codup-repo
    repo_url = f"{GITHUB_RAW_URL}/vertelab/odootools/{branch}/repos/{repo}"
    response = requests.get(repo_url)
    if not response.status_code == 200:
        print(f"Error {response.status_code}  {repo_url}")
    
    for gitrepo in response.text.split('\n'):
        if not gitrepo:
            continue
        author = gitrepo.split('/')[0]
        repobase = gitrepo.split('/')[1].split('.')[0]
        
        if author == 'vertelab':
            target = f"/usr/share/{repobase}"
        else:
            target = f"/usr/share/odooext-{author}-{repobase}"
            
        if os.access(target,os.F_OK):
            print(f"Target {target} already exists")
            continue
        
        try:
            grepo = g.get_repo(f"{author}/{repobase}")
        except Exception as e:
            print(f"Could not read {author}/{repobase} {e}")
            continue
        
        branches = [b.name for b in grepo.get_branches() if re.match("^\d*[.]0$", b.name)]
        if not BRANCH in branches:
            print(f"Branch ({BRANCH}) is missing {author}/{repobase}")
            continue
        # ~ os.system(f"git clone -b {BRANCH} git@github.com:{gitrepo} > /dev/null 2> /dev/null")
        os.system(f"git clone -b {BRANCH} git@github.com:{gitrepo}")
        if os.access(repobase,os.F_OK):
            os.system(f"mv {repobase} {target}")
        else:
            print("ERROR git clone did not work")
            continue
        print(f"{target} fetched")



if LIST:
    repo = g.get_repo(f"vertelab/odootools")
    repos = [c.name for c in repo.get_contents("repos") if re.match(".*-repo$",c.name)]
    print(','.join(repos))
elif REPO:
    clone_repo(REPO,BRANCH)
elif ALL:
    repo = g.get_repo(f"vertelab/odootools")
    print(f'{repo.get_contents("repos/thespino")=}')
    

    for repo in [c.name for c in repo.get_contents("repos") if re.match(".*-repo$",c.name)]:
        #print(repo)
        clone_repo(repo,BRANCH)

