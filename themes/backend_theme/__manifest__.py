# -*- coding: utf-8 -*-
# Copyright 2016 Openworx, LasLabs Inc.
# License LGPL-3.0 or later (http://www.gnu.org/licenses/lgpl.html).

{
    "name": "Community Mobile Backend Theme",
    "summary": "Odoo 10.0 Community Backend Theme (based on Openworx Theme)",
    "version": "10.0.2.0.0",
    "category": "Themes/Backend",
    "website": "http://odooabc.com",
        "description": """
                Backend theme for Odoo 10.0 Community Edition (based on Openworx Theme). More polished and added some responsive CSS rules.
    """,
        'images':[
        'images/screen.png'
        ],
    "author": "Farrell Rafi",
    "license": "LGPL-3",
    "installable": True,
    "depends": [
        'web',
    ],
    "data": [
        'views/assets.xml',
        'views/web.xml',
    ],
}
