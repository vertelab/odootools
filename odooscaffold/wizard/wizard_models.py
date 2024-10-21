# from odoo import models, fields, api, _

# import logging

# _logger = logging.getLogger(__name__)

# class scaffold_test(models.TransientModel):
#     _name = 'scaffold_test.scaffold_test'
#     _description = 'scaffold_test.scaffold_test'
#     _inherit = 'scaffold_test.scaffold_test'

#     name = fields.Char()
#     value = fields.Integer()
#     value2 = fields.Float(compute="_value_pc", store=True)
#     description = fields.Text()
#
#     @api.depends('value')
#     def _value_pc(self):
#         for record in self:
#             record.value2 = float(record.value) / 100
