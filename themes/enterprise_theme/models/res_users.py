# -*- coding: utf-8 -*-
"""Adds functionality to res.users"""
from odoo import models, fields


class ResCompany(models.Model):
    """Model res.users"""
    # pylint: disable=too-few-public-methods

    _inherit = 'res.users'

    background_image = fields.Binary(attachment=True)

    background_allow_users = fields.Boolean(
        related='company_id.background_allow_users',
        readonly=True
    )
