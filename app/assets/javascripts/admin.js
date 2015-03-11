var ready = function() {
  $('#group-users').select2({
    width: '100%',
    ajax: {
      url: Rigidoj.BASE_URL + "/users/search/users",
      dataType: 'json',
      delay: 250,
      data: function(params) {
        return {
          username: params.username
        };
      },
      processResults: function(data) {
        return {
          results: data
        };
      },
      cache: true
    },
    escapeMarkup: function (markup) { return markup; },
    minimumInputLength: 2,
    placeholder: 'Search to add a new user',
    templateResult: function(state) {
      var $state = $(
          '<span><h4>' + state.username + '</h4>' + '<span>' +
          state.name + '</span>'
      );
      return $state;
    },
    templateSelection: function(selection) {
      console.log(selection);
      if (!selection.username) selection.username = selection.text;
      return selection.username;
    }
  });
};

$(document).on('ready page:load', ready);
