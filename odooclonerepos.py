#!/bin/python3
import re
from github import Github
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
g = Github()
repo = g.get_repo(f"vertelab/odootools")

# ~ branches = [b.name for b in repo.get_branches() if re.match("^\d*[.]0$", b.name)]




repos = [c.name for c in repo.get_contents("repos") if re.match(".*-repo$",c.name)]

def clone_repo(repo,branch):
    
    # ~ https://raw.githubusercontent.com/vertelab/odootools/16.0/repos/codup-repo
    repo_url = f"{GITHUB_RAW_URL}/vertelab/odotools/{branch}/repos/{repo}"
    response = requests.get(repo_url)
    if response.status_code == 200:
        print(eval(response.text))
    else:
        print(f"Error {response.status_code}  {repo_url}")
    
    # ~ for gitrepo in 
    # ~ do 
            # ~ repobase=`basename $gitrepo .git`
            # ~ repodir=`dirname $gitrepo`
        # ~ printf "$repobase "
        # ~ if [ $repodir == 'vertelab' ];
        # ~ then
            # ~ target="/usr/share/${repobase}"
        # ~ else
            # ~ target="/usr/share/odooext-${repodir}-${repobase}"
        # ~ fi
        # ~ if [ -d $target ];
        # ~ then
            # ~ printf " already feteched\n"
            # ~ continue
        # ~ fi
        # ~ git clone -b $BRANCH git@github.com:$gitrepo > /dev/null 2> /dev/null
    # ~ #	if [ `ls $repobase/*/__manifest__.py 2> /dev/null |wc -l 2>/dev/null` -gt 0 ]
    # ~ #	then
            # ~ sudo mv $repobase $target
            # ~ printf " fetched\n"
    # ~ #	else
    # ~ #		rm -rf $repo
    # ~ #		printf " empty\n"
    # ~ #	fi
    # ~ done



if LIST:
    repos = [c.name for c in repo.get_contents("repos") if re.match(".*-repo$",c.name)]
    print(','.join(repos))
elif REPO:
    clone_repo(REPO,BRANCH)
elif ALL:
    pass
