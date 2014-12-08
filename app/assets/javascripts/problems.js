$('#problem-listings tbody').on('click', 'tr', function() {
  window.location = $(this).find('a').attr('href');
});

$(document).ready(function() {
  if ($('#problem-content').length) {
    var editor = ace.edit('problem-content');
    editor.setTheme('ace/theme/yesterday');
    editor.getSession().setMode('ace/mode/markdown');
  }
});
