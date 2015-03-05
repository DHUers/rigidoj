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
//= require_self
//= require_tree .

Rigidoj = {};

hljs.initHighlightingOnLoad();
Turbolinks.enableTransitionCache();
Turbolinks.enableProgressBar();

Rigidoj.MessageBus = window.MessageBus;
Rigidoj.MessageBus.callbackInterval = 5000;
Rigidoj.MessageBus.start();

var ready = function() {
  var notificationBadge = $('#notification-badge'),
      notificationsList = $('#notifications'),
      notificationContainer = $('.notification-container', notificationsList),
      notificationNumber = $('.notification-badge-number', notificationBadge);

  Rigidoj.MessageBus.subscribe("/notifications", function(data) {
    var number = $('.notification-badge-number', notificationBadge);
    number.text(parseInt(number.text()) + parseInt(data));
    notificationNumber.addClass('active');
  });

  notificationBadge.click(function() {
    notificationsList.addClass('active');

    $.get('/notifications', function(data) {
      notificationsList.removeClass('active');
      if (data === undefined) {
        return;
      }

      notificationNumber.removeClass('active');
      notificationContainer.empty();
      $.each(data, function() {
        notificationContainer.prepend("<li role='presentation'>" + this.data + "</li>");
      });
    });
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

$(document).ready(ready);
$(document).on('page:load', ready);

$.notifyDefaults({
  template: '<div data-notify="container" class="col-xs-11 col-sm-4 alert alert-{0}" role="alert">' +
              '<button type="button" aria-hidden="true" class="close" data-notify="dismiss">&times;</button>' +
              '<span data-notify="icon"></span> <span data-notify="title">{1}</span>' +
              '<span data-notify="message">{2}</span>' +
              '<a href="{3}" target="{4}" data-notify="url"></a>' +
            '</div>'
});
