$(document).on('page:change', function() {

  $('.solution-form').submit(function() {
    var editorArea = $('.source-editor .source-editor-textarea'),
        editorId = editorArea.attr('id');

    // if cannot find the file, continue
    if (!editorId)
      return true;

    var editor = ace.edit(editorId);
    $('#hidden-raw').val(editor.getSession().getValue());
    return true;
  });

  $('#solution_platform').on('change', function() {
    var selectedValue = $(this).val().toLowerCase();
    var editorArea = $('.source-editor .source-editor-textarea'),
        editorId = editorArea.attr('id');

    // if cannot find the file, continue
    if (!editorId)
      return true;

    var editor = ace.edit(editorId);
    editor.getSession().setMode('ace/mode/' + selectedValue);
  });

});
