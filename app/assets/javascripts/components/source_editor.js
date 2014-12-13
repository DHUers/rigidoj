$(document).on('page:change', function() {
  // setup editor
  var editorContainer = $('.source-editor');
  if (!editorContainer.length)
    return;

  var mode = editorContainer.data('mode');
  var editorArea = editorContainer.find('.source-editor-textarea');
  var previewArea = editorContainer.find('.preview-area');
  var actions = editorContainer.find('.actions select');
  var editor = ace.edit(editorArea.attr('id'));

  editor.setTheme('ace/theme/yesterday');
  editor.getSession().setMode('ace/mode/' + mode);
  editor.setValue($('#hidden-raw').val(), -1);
  actions.each(function() {
    var select = $(this);
    var optionName = select.data('option');
    editor.setOption(optionName, select.val());
    select.on('change', function() {
      editor.setOption(optionName, $(this).val());
    });
  });

  // monitor editor tab click events
  editorContainer.on('click', 'a', function() {
    $('.edit-tab').each(function() {
      $(this).removeClass('selected');
    });

    var tab = $(this);
    tab.addClass('selected');
    var previewUrl = tab.data('preview-url');
    if (previewUrl) {
      editorArea.addClass('hidden');
      previewArea.removeClass('hidden');
      $.ajax({
        url: previewUrl,
        type: 'POST',
        data: {
          raw: editor.getSession().getValue()
        }
      }).done(function(html) {
        $('.preview-area').empty().append(html);
      });
    } else {
      editorArea.removeClass('hidden');
      previewArea.addClass('hidden');
    }
  });
});
