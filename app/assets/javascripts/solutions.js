var ready = function() {

  $('#solution_problem_id').select2({
    width: '100%',
    ajax: {
      url: Rigidoj.BASE_URL + "/query?type_filter=problem&search_for_id=true",
      dataType: 'json',
      delay: 250,
      data: function(params) {
        return {
          term: params.term
        };
      },
      processResults: function(data) {
        return {
          results: data.problems
        };
      },
      cache: true
    },
    escapeMarkup: function (markup) { return markup; },
    minimumInputLength: 1,
    placeholder: 'Select a problem',
    templateResult: function(state) {
      var $state = $(
          '<div><h4>' + state.title + '</h4><span>' + '<span>' +
          state.description_blurb + '</span></div>'
      );
      return $state;
    },
    templateSelection: function(selection) {
      if (selection.text) selection.title = selection.text;
      return selection.title;
    }
  });

  $('#solution_platform').on('change', function() {
    var selectedValue = $(this).val().toLowerCase(),
        editorContainer = $('.source-editor');

    if (!editorContainer)
      return true;

    if (selectedValue === 'c' || selectedValue === 'c++')
      selectedValue = 'c_cpp';
    editorContainer.attr('data-mode', 'ace/mode/' + selectedValue);
  }).select2({width: '100%'});

  $('#solution-listings').on('click', 'tr', function() {
    var solutionId = $(this).find('td:first').text(),
        modal = $('#solution-details'),
        modalBody = modal.find('.modal-body');
    modalBody.empty();
    $.ajax(Rigidoj.BASE_URL + '/solutions/' + solutionId + '/report').done(function(result) {
      modal.find('.modal-body').html(result.report);
    });
    modal.modal();
  });
};
$(document).on('ready page:load', ready);
