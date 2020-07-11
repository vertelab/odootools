# -*- coding: utf-8 -*-
"""Adds functionality to res.company"""
from odoo import models, fields


class ResCompany(models.Model):
    """Model res.company"""
    # pylint: disable=too-few-public-methods

    _inherit = 'res.company'

    background_image = fields.Binary(attachment=True)

    background_allow_users = fields.Boolean(
        string="Allow users to set custom background images"
    )

    dashboard_logo = fields.Boolean(default=True,
                                    string="Show company logo on dashboard")
