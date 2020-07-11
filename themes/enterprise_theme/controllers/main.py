# -*- coding: utf-8 -*-
"""Return background image"""

import base64

from werkzeug.utils import redirect
from odoo.http import Controller, request, route


DEFAULT_IMAGE_PATH = '/enterprise_theme/static/src/img/dashboard.jpg'


class DasboardBackground(Controller):
    """Dashboard background controller"""

    @route(['/background'], type='http', auth='user', website=False)
    def background(self, **post):
        """Redirects to the background image"""
        user = request.env.user
        company = user.company_id
        if company.background_allow_users and user.background_image:
            image = base64.b64decode(user.background_image)
        elif company.background_image:
            image = base64.b64decode(company.background_image)
        else:
            return redirect(DEFAULT_IMAGE_PATH)

        return request.make_response(image, [('Content-Type', 'image')])
