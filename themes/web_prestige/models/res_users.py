from odoo import models, api, fields

class Users(models.Model):
    _inherit = 'res.users'

    notification_type = fields.Selection(
        selection=[
            ('email', 'Handle by Emails'),
            ('inbox', 'Handle in Discuss'),
        ]
    )
    odoobot_state = fields.Selection(string='Yantra Status')
