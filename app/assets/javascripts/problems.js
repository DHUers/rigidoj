$(document).on('page:change', function() {

  $('.problem-form').submit(function() {
    var editorArea = $('.source-editor .source-editor-textarea'),
        editorId = editorArea.attr('id');

    // if cannot find the file, continue
    if (!editorId)
      return true;

    var editor = ace.edit(editorId);
    $('#hidden-raw').val(editor.getSession().getValue());
    return true;
  });

  $('#problem_judge_type').on('change', function() {
    var selectedValue = $(this).val();
    $('.judge-source-group').each(function(i) {
      if (i == selectedValue) {
        $(this).removeClass('hidden');
      } else {
        $(this).addClass('hidden');
      }
    });
  });

});
