# -*- coding: utf-8 -*-

# License LGPL-3.0 or later (http://www.gnu.org/licenses/lgpl.html).

from odoo import models, fields

class ResCompany(models.Model):

    _inherit = 'res.company'

    dashboard_background = fields.Binary(attachment=True,
                                         help='Add a custom image to the background of the main application menu.\
                                          Recommended measures width = 1600px, height = 900px.')