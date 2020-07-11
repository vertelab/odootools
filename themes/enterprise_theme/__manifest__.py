# -*- coding: utf-8 -*-
# Copyright 2016, 2017 Openworx
# Copyright 2017 Hugo Rodrigues
# License LGPL-3.0 or later (http://www.gnu.org/licenses/lgpl.html).
# pylint: disable=pointless-statement
# pylint: disable=missing-docstring

{
    "name": "Enterprise Backend Theme",
    "summary": "Enterprise feel on Odoo Community",
    "version": "11.0.1.0.2",
    "category": "Themes/Backend",
    "website": "https://hugorodrigues.net",
    "author": "Openworx, Hugo Rodrigues",
    "license": "LGPL-3",
    "installable": True,
    "images": [
        "static/description/dashboard.png"
    ],
    "depends": [
        'web_responsive',
    ],
    "excludes": [
        'web_enterprise',
        'backend_theme_v11'
    ],
    "data": [
        'views/assets.xml',
        'views/res_company_view.xml',
        'views/res_users_view.xml',
        'views/web.xml',
    ],
}
