$(document).on('page:change', function() {
  // setup editor
  $('.source-editor').each(function() {
    var container = $(this);
    var mode = container.data('mode');
    var editorArea = container.find('textarea');
    var previewArea = container.find('.preview-area');

    var actions = container.find('.actions select');

    // build a edit div for ACE since ACE can't load in a textarea
    var editDiv = $('<div>', {
      position: 'absolute',
      width: editorArea.width(),
      height: editorArea.height(),
      'class': editorArea.attr('class')
    }).insertBefore(editorArea);
    editorArea.css('display', 'none');

    var editor = ace.edit(editDiv[0]);

    editor.setTheme('ace/theme/yesterday');
    editor.getSession().setMode('ace/mode/' + mode);
    actions.each(function() {
      var select = $(this);
      var optionName = select.data('option');
      editor.setOption(optionName, select.val());
      select.on('change', function() {
        editor.setOption(optionName, 0);
      });
    });

    // monitor editor tab click events
    container.on('click', 'a', function() {
      $('.edit-tab').each(function () {
        $(this).removeClass('selected');
      });

      var tab = $(this);
      tab.addClass('selected');
      var previewUrl = tab.data('preview-url');
      if (previewUrl) {
        editDiv.addClass('hidden');
        previewArea.removeClass('hidden');
        $.ajax({
          url: previewUrl,
          type: 'POST',
          data: {
            raw: editor.getSession().getValue()
          }
        }).done(function (html) {
          $('.preview-area').empty().append(html);
        });
      } else {
        editDiv.removeClass('hidden');
        previewArea.addClass('hidden');
      }
    });
  });
});
