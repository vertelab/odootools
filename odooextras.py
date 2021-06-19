#!/usr/bin/python3
##############################################################################
#                     Download additional odoo resources                     #
#                                                                            #
#  Additional repos collected from Github, using list on Vertel repo on      #
#  Github.                                                                   #
#  Additional themes collected from Vertel repo on Github.                   #
#                                                                            #
#  Usage:                                                                    #
#      odooextras.py subdir1 [subdir2]                                       #
#  To get both additional repos and themes:                                  #
#      odooextras.py repos themes                                            #
##############################################################################

import json
import os
import shutil
import subprocess
import sys

ODOO_VERSION = '14.0'
BASE_URL = f'https://raw.githubusercontent.com/vertelab/odootools/{ODOO_VERSION}'
TARGET_DIR = '/usr/share'
THEME_DIR = f'{TARGET_DIR}/odooext-themes'
VERTEL_PREFIX = ''
EXTERNAL_PREFIX = 'odooext-{repodir}-'


def setrights(path):
    for root, dirs, files in os.walk(path):
        try:
            # chmod works on octals
            os.chmod(root, int('775', 8))
            shutil.chown(root, 'odoo', 'odoo')
        except (PermissionError, FileNotFoundError):
            pass

        for f in files:
            try:
                target = os.path.join(root, f)
                # chmod works on octals
                os.chmod(target, int('664', 8))
                shutil.chown(target, 'odoo', 'odoo')
            except (PermissionError, FileNotFoundError):
                pass

def get_subdir(subdir, tree):
    for node in tree:
        path = node.get('path')
        git_path = f'{BASE_URL}/{path}'
        if path.startswith(subdir):
            if subdir in ('repos',) and path.endswith('-repo'):
                p = subprocess.run(['wget', '-O', '-', git_path], stdout=subprocess.PIPE)
                for gitrepo in [x for x in str(p.stdout, 'utf-8').split('\n') if x.strip()]:
                    repodir = os.path.dirname(gitrepo)
                    repobase = os.path.basename(gitrepo)
                    reponame = os.path.splitext(repobase)[0]
                    prefix = VERTEL_PREFIX if repodir == 'vertelab' else EXTERNAL_PREFIX.format(**locals())
                    target = f'{TARGET_DIR}/{prefix}{repobase}'
                    if os.path.exists(target):
                        print(f'Repo already fetched: {target}')
                        continue
                    p = subprocess.run(['git', 'clone', '-b', ODOO_VERSION, f'git@github.com:{gitrepo}'])
                    # Could not find repo
                    if p.returncode == 128:
                        continue
                
                    setrights(reponame)
                    try:
                        shutil.move(reponame, target)
                    except FileNotFoundError:
                        print(f'Failed to move {reponame}, could not find it.')
                    except PermissionError:
                        print(f'Failed to move {reponame} due to permission error.')
                    print(f'{reponame} fetched')

        elif subdir in ('themes', ):
            target = f'{THEME_DIR}/{path}'
            if path in ('themes', 'themes/install', 'themes/Makefile', 'themes/unzipall') or  path.startswith('themes/zip'):
                continue
            os.makedirs(os.path.dirname(target), exist_ok=True)
            p = subprocess.run(['wget', '-O', target, f'{git_path}'])
    if subdir in ('themes',):
        setrights(theme_dir)

def get_file_tree():
    cmd = ['wget',
           '-O-',
           f'https://api.github.com/repos/vertelab/odootools/git/trees/{ODOO_VERSION}?recursive=1']
    p = subprocess.run(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    data = json.loads(p.stdout)
    return data.get('tree', [])
    

if __name__ == '__main__' and len(sys.argv) > 1:
    tree = get_file_tree()
    for subdir in sys.argv[1:]:
        get_subdir(subdir, tree)

