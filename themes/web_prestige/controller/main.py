import odoo
from odoo import http
from odoo.http import request
from odoo.addons.web.controllers.main import Home, Database, DBNAME_PATTERN
import jinja2
import os
import json
import sys

db_monodb = http.db_monodb

if hasattr(sys, 'frozen'):
    # When running on compiled windows binary, we don't have access to package loader.
    path = os.path.realpath(os.path.join(os.path.dirname(__file__), '..', 'views'))
    loader = jinja2.FileSystemLoader(path)
else:
    loader = jinja2.PackageLoader('odoo.addons.web_prestige', "views")

env = jinja2.Environment(loader=loader, autoescape=True)
env.filters["json"] = json.dumps

class ExtendHome(Home):

    @http.route('/web/login', type='http', auth="none")
    def web_login(self, redirect=None, **kw):
        main_company = request.env.ref('base.main_partner' ,raise_if_not_found=False)
        request.params['title'] = main_company.sudo().name if main_company else False
        return super(ExtendHome, self).web_login(redirect, **kw)


class ExtendDatabase(Database):
    def _render_template(self, **d):
        d.setdefault('manage',True)
        d['insecure'] = odoo.tools.config.verify_admin_password('admin')
        d['list_db'] = odoo.tools.config['list_db']
        d['langs'] = odoo.service.db.exp_list_lang()
        d['countries'] = odoo.service.db.exp_list_countries()
        d['pattern'] = DBNAME_PATTERN
        # databases list
        d['databases'] = []
        try:
            d['databases'] = http.db_list()
            d['incompatible_databases'] = odoo.service.db.list_db_incompatible(d['databases'])
        except odoo.exceptions.AccessDenied:
            monodb = db_monodb()
            if monodb:
                d['databases'] = [monodb]
        return env.get_template("database_manager.html").render(d)
