#!/usr/bin/python3
import json
import os
import shutil
import subprocess
import sys

ODOO_VERSION = '14.0'
SUBDIR =  sys.argv[1] if len(sys.argv) > 1 else ''
BASE_URL = f'https://raw.githubusercontent.com/vertelab/odootools/{ODOO_VERSION}'
TARGET_DIR = '/usr/share'

data = json.loads(sys.stdin.read())
tree = data.get('tree', [])

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
                os.chmod(target, int('665', 8))
                shutil.chown(target, 'odoo', 'odoo')
            except (PermissionError, FileNotFoundError):
                pass

if SUBDIR in ('themes'):
    theme_dir = f'{TARGET_DIR}/odooext-themes'
    os.makedirs(theme_dir, exist_ok=True)
            
for node in tree:
    path = node.get('path')
    if path.startswith(SUBDIR):
        if SUBDIR in ('repos',) and path.endswith('-repo'):
            git_path = f'{BASE_URL}/{path}'
            p = subprocess.run(['wget', '-O', '-', git_path], stdout=subprocess.PIPE)
            for gitrepo in [x for x in str(p.stdout, 'utf-8').split('\n') if x.strip()]:
                repodir = os.path.dirname(gitrepo)
                repobase = os.path.basename(gitrepo)
                reponame = os.path.splitext(repobase)[0]
                ext = '' if repodir == 'vertelab' else f'odooext-{repodir}-'
                target = f'{TARGET_DIR}/{ext}{repobase}'
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
                break
        elif SUBDIR in ('themes', ):
            base_path = path.split('/', 1)[-1]
            if path in ('themes', 'themes/install', 'themes/Makefile', 'themes/unzipall') or  path.startswith('themes/zip'):
                continue
            p = subprocess.run(['wget', '-O', f'{theme_dir}/{path}', path])

if SUBDIR in ('themes'):
    setrights(theme_dir)





