// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$(function() {
  var engine = new Bloodhound({
    remote: '/query?include_blurbs=true&type_filter=problem&term=%QUERY',
    datumTokenizer: function(d) {
      return Bloodhound.tokenizers.whitespace(d.val);
    },
    queryTokenizer: Bloodhound.tokenizers.whitespace
  });
  engine.initialize();
  $('#search-add-problem').typeahead({
    hint: true,
    minLength: 1,
    highlight: true
  }, {
    name: 'someName',
    displayKey: 'DisplayText',
    source: engine.ttAdapter()
  });
});
