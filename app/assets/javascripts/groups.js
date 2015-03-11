var ready = function() {
  $('#group_user_ids').select2({
    width: '100%'
  });
};
$(document).on('ready page:load', ready);
