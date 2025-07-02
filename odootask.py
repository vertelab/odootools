#!/usr/bin/env python3
"""
odootask -p <project> or odootask -> List open tasks
odootask -t <task_number>         -> display task description 

~/.odoorpcrc
...
[projectdb]
type = ODOO
protocol = jsonrpc
host = your server
port = 8069
database = database name
user = your user
timeout = 120.0
passwd = password
...
"""

import argparse
import os
import odoorpc
from bs4 import BeautifulSoup


ODOORPCRC_PATH = os.path.expanduser("~/.odoorpcrc")
SESSION_NAME = "projectdb"

def main(project_name, my_only, task_number):
    if not os.path.exists(ODOORPCRC_PATH):
        print(f"Error: File '{ODOORPCRC_PATH}' missing. Create session projectdb with database credentials.", file=sys.stderr)
        sys.exit(1)
    if SESSION_NAME not in odoorpc.ODOO.list(ODOORPCRC_PATH):
        print(f"Error: Session '{SESSION_NAME}' missing in {ODOORPCRC_PATH}. Create this with database credentials", file=sys.stderr)
        sys.exit(1)

    odoo = odoorpc.ODOO.load(SESSION_NAME)



def main(project_name, my_only, task_number):
    odoo = odoorpc.ODOO.load('projectdb')

    if task_number:
        tasks = odoo.env['project.task'].search([('number', '=', task_number)], limit=1)
        if not tasks:
            print("No task found with that number.")
            return
        task = odoo.env['project.task'].browse(tasks[0])
        print(f"{task.number} {task.name} {task.user_id.name}\n{BeautifulSoup(task.description or '', 'html.parser').get_text()}")
        return

    if not project_name:
        project_name = os.path.basename(os.getcwd())
    project_ids = odoo.env['project.project'].search([('name', 'ilike', project_name)])
    if not project_ids:
        print("No project found with that name.")
        return

    # Find the 'Analys' stage for this project
    stage_ids = odoo.env['project.task.type'].search([('project_ids', 'in', project_ids[0]), ('name', '=', 'Analys')])
    if not stage_ids:
        print("No 'Analys' stage found for this project.")
        return
    stage_id = stage_ids[0]

    domain = [
        ('project_id', '=', project_ids[0]),
        ('stage_id', '=', stage_id)
    ]
    if my_only:
        user = odoo.env.user  # Only fetch here!
        domain.append(('user_id', '=', user.id))

    tasks = odoo.env['project.task'].search(domain)
    if not tasks:
        print("No tasks found.")
        return

    for t in tasks:
        task = odoo.env['project.task'].browse(t)
        print(f"{task.number} {task.name}  {task.user_id.name or 'No-one-yet'}")




if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("-p", "--project", default=None, help="Project name (defaults to current directory)")
    parser.add_argument("--my", action="store_true", help="Filter to my tasks")
    parser.add_argument('-t', "--task", default=None, help="Get this task number")

    args = parser.parse_args()
    main(args.project, args.my, args.task)

