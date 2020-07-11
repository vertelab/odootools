# -*- coding: utf-8 -*-
# Copyright 2016 Openworx, LasLabs Inc.
# Copyright 2017 Edi Santoso <repodevs@gmail.com>
# License LGPL-3.0 or later (http://www.gnu.org/licenses/lgpl.html).

{
    "name": "Responsive Backend Theme - Purple",
    "summary": "Odoo 10.0 Community Backend Theme Purple Color",
    "version": "10.0.1.0.0",
    "category": "Themes/Backend",
    "website": "https://me.repodevs.com",
	"description": """
        Backend theme for Odoo 10.0 Community Edition (based on Openworx Theme). More polished to match the purple color.
		The app dashboard is based on the module web_responsive from LasLabs Inc and the theme on Bootstrap United.
    """,
	'images':[
        'images/screen.png'
	],
    "author": "Edi Santoso",
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

