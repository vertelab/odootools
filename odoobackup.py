#!/usr/bin/env python3
import odoo
import click

@click.command()
@click.option('--database', prompt='database', help='Database to backup.')
@click.option('--filename', prompt='filename', help='File Name to save the Backup.')
def backup(database,filename):
    backup = odoo.service.db.dump_db(database,None)
    with open(filename,'wb') as f:
        f.write(backup.read())
    backup.close()
    
if __name__ == '__main__':
    backup()

 
