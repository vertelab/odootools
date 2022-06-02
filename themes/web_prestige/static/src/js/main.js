odoo.define('web_prestige.Dialog', function (require) {
  "use strict";

  var core = require('web.core');
  var Dialog = require('web.Dialog');
  var session = require('web.session');

  var _t = core._t;
  var [, currentCompany] = session["user_companies"]["current_company"] || [0, "Prestige"];

  Dialog.include({
    init: function (parent, options) {
      var title;
      this._super(parent, options);

      switch (options.title) {
        case _t('Odoo'): {
          title = _(currentCompany)
          break;
        }

        case _t('Odoo Error'): {
          title = _(currentCompany + ': Error')
          break;
        }

        case _t('Odoo Warning'): {
          title = _(currentCompany + ': Warning')
          break;
        }

        default: {
          title = currentCompany + ' : ' + options.title
        }
      }

      this.title = title;
    }
  });

  return Dialog;
});

odoo.define('web_prestige.AbstractWebClient', function (require) {
  'use strict';

  const AbstractWebClient = require('web.AbstractWebClient');
  var session = require('web.session');

  var [, currentCompany] = session["user_companies"]["current_company"] || [0, "Prestige"];
  AbstractWebClient.include({
    init: function () {
      this._super.apply(this, arguments);
      this.set('title_part', { 'zopenerp': currentCompany });
    }
  });

  return AbstractWebClient;
});

odoo.define('web_prestige.AppsMenu', function (require) {
  "use strict";
  var AppsMenu = require('web.AppsMenu');

  AppsMenu.include({
    /**
     * @override
     * @param {web.Widget} parent
     * @param {Object} menuData
     * @param {Object[]} menuData.children
     */
    init: function (parent, menuData) {
      this._super.apply(this, arguments);
      this._apps = _.map(menuData.children, function (appMenuData) {
        var [moduleName, webIcon = false] = (appMenuData.web_icon || '').split(',');
        return {
          actionID: parseInt(appMenuData.action.split(',')[1]),
          menuID: appMenuData.id,
          name: appMenuData.name,
          xmlID: appMenuData.xmlid,
          module: moduleName,
          webIcon: webIcon && moduleName ? moduleName + '/' + webIcon : false,
        };
      });
    },
  });

  return AppsMenu;
});

odoo.define('web_prestige.basic_fields', function (require) {
  "use strict";
  var basic_fields = require('web.basic_fields');

  basic_fields.InputField.include({

    /**
     * @override
     * @param {jQuery|undefined} $input
     */
    _prepareInput($input) {
      this.attrs.autocomplete = 'off';
      return this._super($input);
    }
  });

  return basic_fields;
});

odoo.define('web_prestige.MailBotService', function (require) {
  'use strict';

  var core = require('web.core');
  var MailBotService = require('mail_bot.MailBotService');

  var _t = core._t;

  MailBotService.include({

    /**
     * Get the previews related to the OdooBot (conversation not included).
     * For instance, when there is no conversation with OdooBot and OdooBot has
     * a request, it should display a preview in the systray messaging menu.
     *
     * @param {string|undefined} [filter]
     * @returns {Object[]} list of objects that are compatible with the
     *   'mail.Preview' template.
     */
    getPreviews: function (filter) {
      if (!this.isRequestingForNativeNotifications()) {
        return [];
      }
      if (filter && filter !== 'mailbox_inbox') {
        return [];
      }
      var previews = [{
        title: _t("You have a pending request"),
        imageSRC: "/mail/static/src/img/odoobot.png",
        status: 'bot',
        body: _t("Enable desktop notifications to chat"),
        id: 'request_notification',
        unreadCounter: 1,
      }];
      return previews;
    },

  });

  return MailBotService;
});

odoo.define('web_prestige.MessagingMenu', ['mail_bot.systray.MessagingMenu', 'mail.systray.MessagingMenu', 'web.core'], function (require) {
  'use strict';

  var MessagingMenu = require('mail.systray.MessagingMenu');
  var core = require('web.core');

  var _t = core._t;

  MessagingMenu.include({

    /**
     * Handle the response of the user when prompted whether push notifications
     * are granted or denied.
     *
     * Also refreshes the counter after a response from a push notification
     * request. This is useful because the counter contains a part for the
     * OdooBot, and the OdooBot influences the counter by 1 when it requests
     * for notifications. This should no longer be the case when push
     * notifications are either granted or denied.
     *
     * @private
     * @param {string} value
     */
    _handleResponseNotificationPermission: function (value) {
      this.call('mailbot_service', 'removeRequest');
      if (value !== 'granted') {
        this.call('bus_service', 'sendNotification', _t('Permission denied'),
          _t('System will not have the permission to send native notifications on this device.'));
      }
      this._updateCounter();
    },

  });


  return MessagingMenu;
});
