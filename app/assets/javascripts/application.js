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
//= require select2
//= require typeahead.bundle
//= require message-bus
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
};

$(document).ready(ready);
$(document).on('page:load', ready);
