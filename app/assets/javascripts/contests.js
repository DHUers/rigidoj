// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$(function() {
  var engine = new Bloodhound({
    remote: {
      url: '/query?include_blurbs=true&search_for_id=true&type_filter=problem&term=%QUERY',
      filter: function(parsedResponse) {
        var a = $.map(parsedResponse.problems, function(problem) {
          return {
            id: problem.id,
            value: problem.baked
          }
        });
        console.log(a);
        return a;
      }
    },
    datumTokenizer: function(d) {
      console.log(d);
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
    name: 'problem-item',
    displayKey: 'value',
    source: engine.ttAdapter()
  });
});
