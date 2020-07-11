# -*- coding: utf-8 -*-
# Copyright 2019-Present Lekhnath Rijal<inboxlekhnath@gmail.com>
# License LGPL-3.0 or later (http://www.gnu.org/licenses/lgpl.html).

from odoo import models

class Http(models.AbstractModel):
    _inherit = 'ir.http'

    def webclient_rendering_context(self):
        qcontext = super(Http, self).webclient_rendering_context()
        main_company = self.env.ref('base.main_partner' ,raise_if_not_found=False)
        qcontext.update({
            'title': main_company.sudo().name if main_company else False,
            'x_icon': 'web_prestige/static/img/favicon.png',
        })

        return qcontext
