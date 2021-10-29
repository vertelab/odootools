#!/usr/bin/env python3
import odoo
import click


@click.command()
@click.option('--database', prompt='database', help='Database to backup.')
@click.option('--filename', prompt='filename', help='File Name to save the Backup.')
@click.option('--host', prompt='host', help='Database Host name.')
@click.option('--db_port', prompt='db_port', help='Database working Port.')
@click.option('--db_user', prompt='db_user', help='Database User.')
@click.option('--db_password', prompt='db_password', help='Database Password.')
@click.option('--stream', prompt='stream', help='if stream is None return a file object with the dump')
def backup(database, filename):
    odoo.tools.config['db_port'] = db_port
    odoo.tools.config['db_host'] = host
    odoo.tools.config['db_user'] = db_user
    odoo.tools.config['db_password'] = db_password
    backup = odoo.service.db.dump_db(database, stream)
    with open(filename, 'wb') as f:
        f.write(backup.read())
    backup.close()
    
if __name__ == '__main__':
    backup()
