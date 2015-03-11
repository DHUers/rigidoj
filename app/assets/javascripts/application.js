// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require jquery-ui
//= require jquery-watch
//= require bootstrap-sprockets
//= require turbolinks
//= require highlight.pack
//= require ace/ace
//= require ace/worker-html
//= require ace/theme-yesterday
//= require ace/ext-language_tools
//= require ace/mode-markdown
//= require ace/mode-c_cpp
//= require ace/mode-java
//= require typeahead.bundle
//= require message-bus
//= require jquery.waypoints
//= require sticky
//= require moment
//= require bootstrap-datetimepicker
//= require select2
//= require smooth-scroll
//= require bootstrap-notify
//= require refile
//= require rigidoj
//= require_self
//= require_tree .

hljs.initHighlightingOnLoad();
Turbolinks.enableTransitionCache();
Turbolinks.enableProgressBar();

Rigidoj.MessageBus = window.MessageBus;
Rigidoj.MessageBus.callbackInterval = 5000;
Rigidoj.MessageBus.baseUrl = Rigidoj.BASE_URL + '/';
Rigidoj.MessageBus.start();

var ready = function() {
  var notificationBadge = $('#notification-badge'),
      notificationsList = $('#notifications'),
      notificationMarkRead = $('.mark-read', notificationsList),
      notificationNumber = $('.notification-badge-number', notificationBadge);

  Rigidoj.MessageBus.subscribe("/notifications", function(data) {
    notificationNumber.text(parseInt(notificationNumber.text()) + parseInt(data));
    notificationNumber.addClass('active');
    $.get(Rigidoj.BASE_URL + '/notifications').done(function(data) {
      notificationsList.removeClass('active');
      if (data === undefined) {
        return;
      }

      var wrapperName = '.notifications-wrapper',
          wrapper = $('.notifications-wrapper', notificationsList);
      wrapper.empty().html($($(data).find(wrapperName)[0]).html());
    });
  });

  notificationMarkRead.on('click', function(e) {
    notificationIds = $('.notification-item.unread', notificationsList).map(function() {
      return $(this).data('notification-id');
    }).get();
    if (notificationIds !== undefined && notificationIds.length > 0) {
      $.post(Rigidoj.BASE_URL + '/notifications/read', { notificationIds: notificationIds }).done(function() {
        notificationNumber.removeClass('active');
        notificationNumber.text('0');
      });
    }
  });

  if ($('.sticky').length != 0) {
    var sticky = new Waypoint.Sticky({
      element: $('.sticky'),
      handler: function() {
        $('.stuck').width($('.action-list').width());
      }
    });
  }

  $('.row-clickable').each(function() {
    var element = $(this).data('element');
    $(this).on('click', element, function() {
      window.location.href = $(this).find('a').attr('href');
    });
  });

  $('time.realtime').each(function() {
    var ele = $(this);
    setInterval(function() {
      ele.text(moment().format('hh:mm:ss'));
    }, 1000);
  });
};

$(document).on('ready page:load', ready);

$.notifyDefaults({
  template: '<div data-notify="container" class="col-md-11 col-sm-4 alert alert-{0}" role="alert">' +
              '<button type="button" aria-hidden="true" class="close" data-notify="dismiss">&times;</button>' +
              '<span data-notify="icon"></span> <span data-notify="title">{1}</span>' +
              '<span data-notify="message">{2}</span>' +
              '<a href="{3}" target="{4}" data-notify="url"></a>' +
            '</div>'
});
