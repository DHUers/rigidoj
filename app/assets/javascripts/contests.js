// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$(function() {
  var engine = new Bloodhound({
    remote: {
      url: '/query?include_blurbs=true&search_for_id=true&type_filter=problem&term=%QUERY',
      filter: function(parsedResponse) {
        return $.map(parsedResponse.problems, function(problem) {
          return {
            id: problem.id,
            value: "<h1><span>" + problem.id + "</span>" + problem.title + "</h1>" +
                   "<div class='content'><p>" + problem.description_blurb + "</p></div>"
          }
        });
      }
    },
    datumTokenizer: function(d) {
      return Bloodhound.tokenizers.whitespace(d.val);
    },
    queryTokenizer: Bloodhound.tokenizers.whitespace
  });
  engine.initialize();

  var addProblemInputElement = $('#search-add-problem'),
      problemLists = $('#problem-lists');
  addProblemInputElement.typeahead({
    hint: true,
    minLength: 1,
    highlight: true
  }, {
    name: 'problem-item',
    source: engine.ttAdapter()
  }).on('typeahead:selected', function(e, suggestion, name) {
    addProblemInputElement.val('');
    var item = "<div class='well "+ name +"' data-problem-id='" + suggestion.id + "'>" +
               suggestion.value + "</div>";
    problemLists.append(item);
  }).on('blur', function() {
    // typeahead will set query according to value, so nuke it
    addProblemInputElement.val('');
  });
});
