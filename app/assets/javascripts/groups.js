var ready = function() {
  $('#group_user_ids').select2({
    width: '100%'
  });
};

$(document).ready(ready);
$(document).on('page:load', ready);

