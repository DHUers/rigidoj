var ready = function() {

  $('#solution_platform').on('change', function() {
    var selectedValue = $(this).val().toLowerCase(),
        editorContainer = $('.source-editor');

    if (!editorContainer)
      return true;

    if (selectedValue === 'c' || selectedValue === 'c++')
      selectedValue = 'c_cpp';
    editorContainer.attr('data-mode', 'ace/mode/' + selectedValue);
  });

};

$(document).ready(ready);
$(document).on('page:load', ready);
