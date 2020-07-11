# -*- coding: utf-8 -*-
# License LGPL-3.0 or later (http://www.gnu.org/licenses/lgpl.html).

{
    "name": "Enterprise Backend Theme",
    "summary": "Customize odoo v12.0 Community Edition with the menu, colored buttons and background of Odoo Enterprise,responsive web theme and global search menu.",
    "version": "12.0.0.1",
    "category": "Theme/Backend",
    "website": "https://www.youtube.com/c/JuventudProductivaVenezolana?sub_confirmation=1",
    "description": """
        Enterprise Backend Theme for Odoo 12.0 community edition.
        Material Theme
        Backend
        backend theme
        responsive backend theme
        responsive frontend theme
        responsive web theme
        global search
        fully responsive
        User Interface
        Odoo ERP
        submenu
        main menu
        toggle
        ui ux
        ui & ux
        bootstrap
        Customized Layouts
        Menu bar
        Submenu bar
        Control Panel
        List view
        Search option layout
        Form view action buttons
        Dashboard
        Kanban View
        List View Form View
        Graph View Pivot View
        General View
        Calendar View
        Planner view Chat Panel
        variations
        color palette
        default color panel
        default colour panel
        colour scheme
        Dynamic Graph view
        desktop layout
        tablet layout
        mobile layout
        desktop view
        tablet view
        mobile view
        favourite bar
        full width
        horizontal tab
        vertical tab
        normal view
        light view
        night view
        customized icons
        isometric icon
        base icon
        dynamic color palette
        dynamic colour palette
        display density
        horizontal menu
        vertical menu
        full screen
        default form view
        comfortable
        compact
        Juventud Productiva
        Juventud Productiva Venezolana
        flexible
        fuzzy search
        theme color
        theme colour
        app icon
        without global search
    """,
    "author": "JUVENTUD PRODUCTIVA VENEZOLANA",
    "license": "LGPL-3",
    "installable": True,
    "depends": [
        'web',
        'web_responsive',

    ],
    "data": [
        'views/assets.xml',
        'views/res_company_view.xml',
        'views/users.xml',
    ],
    'images': [
        'static/description/banner.png',
        'static/description/jpv_theme_screenshot.png', 
    ],
    # ~ 'price': 0.0,
    # ~ 'currency': 'EUR',
    'live_test_url': 'https://www.youtube.com/c/JuventudProductivaVenezolana?sub_confirmation=1',
}

