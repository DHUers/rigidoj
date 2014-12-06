// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(document).ready(function() {
  if ($('#problem-content').length) {
    var editor = ace.edit('problem-content');
    editor.setTheme('ace/theme/yesterday');
    editor.getSession().setMode('ace/mode/markdown');
  }
});
