$(document).on('ready page:change', function() {
  // setup editor
  $('.source-editor').each(function(i) {
    var container = $(this);
    if (container.data('loaded')) return;
    container.data('loaded', 'true');
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
    editorArea.hide();

    var editor = ace.edit(editDiv[0]);

    editor.setFontSize('14px');
    editor.setOptions({
      enableBasicAutocompletion: true
    });
    editor.setTheme('ace/theme/yesterday');
    editor.getSession().setMode('ace/mode/' + mode);
    editor.getSession().setValue(editorArea.val());

    // save back to the textarea when submit
    editorArea.closest('form').submit(function() {
      editorArea.val(editor.getSession().getValue());
    });

    // watch DOM data-mode for setting mode. a bit hacky
    $(this).watch({
      properties: 'attr_data-mode',
      callback: function(data) {
        editor.getSession().setMode(data.vals[0]);
      }
    });

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
