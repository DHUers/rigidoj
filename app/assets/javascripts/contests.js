var ready = function() {
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
      appendProblemItem = function(id) {
        $.get("/problems/" + id + "/excerpt", function(data) {
          problemLists.append(data);
        });
      };

  addProblemInputElement.typeahead({
    hint: true,
    minLength: 1,
    highlight: true
  }, {
    name: 'problem-item',
    source: engine.ttAdapter()
  }).on('typeahead:selected', function(e, suggestion) {
    addProblemInputElement.val('');
    appendProblemItem(suggestion.id);
  }).on('blur', function() {
    // typeahead will set query according to value, so nuke it
    addProblemInputElement.val('');
  });

  // extract problem lists when submit
  problemLists.closest('form').submit(function() {
    var lists = $('#problem-lists .problem-info').map(function() {
      return String($(this).data('problem-id'));
    }).get();
    $('#hidden-problem-list').val(JSON.stringify(lists));
  });

  problemLists.sortable();
  problemLists.on('click', '.delete-problem', function() {
    $(this).parent().remove();
  });

  $('.datetimepicker').each(function() {
    $(this).datetimepicker({
      format: 'YYYY-MM-DD HH:mm'
      });
  });
  var startAtDateTimePicker = $('#started-at-datetimepicker'),
      endAtDateTimePicker = $('#end-at-datetimepicker'),
      delayedTillDateTimePicker = $('#delayed-till-datetimepicker');
  startAtDateTimePicker.on('dp.change', function(e) {
    endAtDateTimePicker.data('DateTimePicker').minDate(e.date);
    delayedTillDateTimePicker.data('DateTimePicker').minDate(e.date);
  });
  endAtDateTimePicker.on('dp.change', function(e) {
    startAtDateTimePicker.data('DateTimePicker').maxDate(e.date);
    delayedTillDateTimePicker.data('DateTimePicker').minDate(e.date);
  });
  delayedTillDateTimePicker.on('dp.change', function(e) {
    startAtDateTimePicker.data('DateTimePicker').minDate(e.date);
    endAtDateTimePicker.data('DateTimePicker').minDate(e.date);
  });
};

$(document).ready(ready);
$(document).on('page:load', ready);
