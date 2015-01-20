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
      problemLists = $('#problem-lists'),
      appendProblemItem = function(id, name) {
        $.get("/problems/" + id + "/excerpt", function(data) {
          problemLists.append('<li class="well ' + name + '">' + data + '</li>');
        });
      };

  addProblemInputElement.typeahead({
    hint: true,
    minLength: 1,
    highlight: true
  }, {
    name: 'problem-item',
    source: engine.ttAdapter()
  }).on('typeahead:selected', function(e, suggestion, name) {
    addProblemInputElement.val('');
    appendProblemItem(suggestion.id, name);
  }).on('blur', function() {
    // typeahead will set query according to value, so nuke it
    addProblemInputElement.val('');
  });

  // extract problem lists when submit
  problemLists.closest('form').submit(function() {
    var additionalLimitGroup = $('.additional-limit-group').map(function(_,v) {
      var group = $(v),
          platform = group.find('.platform span').text(),
          timeLimit = group.find('.time-limit-group input').val(),
          memoryLimit = group.find('.memory-limit-group input').val();
      return {
        platform: platform,
        timeLimit: timeLimit,
        memoryLimit: memoryLimit
      };
    }).get();
    $('#problem_additional_limits').val(JSON.stringify(additionalLimitGroup));
  });

  problemLists.sortable({
    update: function() {
      $('.problem-info', problemLists).each(function(index, elem) {
        var $listItem = $(elem),
            newIndex = $listItem.index();

        // Persist the new indices.
      });
    }
  }).on('click', '.delete-problem', function() {
    $(this).parent().remove();
  });

});
