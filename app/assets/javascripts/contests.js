var ready = function() {
  var problemLists = $('#problem-lists');

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
      delayedTillDateTimePicker = $('#delayed-till-datetimepicker'),
      frozenRanklistFromDateTimePicker = $('#frozen-ranklist-from-datetimepicker');
  startAtDateTimePicker.on('dp.change', function(e) {
    endAtDateTimePicker.data('DateTimePicker').minDate(e.date);
    delayedTillDateTimePicker.data('DateTimePicker').minDate(e.date);
    frozenRanklistFromDateTimePicker.data('DateTimePicker').minDate(e.date);
  });
  endAtDateTimePicker.on('dp.change', function(e) {
    startAtDateTimePicker.data('DateTimePicker').maxDate(e.date);
    delayedTillDateTimePicker.data('DateTimePicker').minDate(e.date);
    frozenRanklistFromDateTimePicker.data('DateTimePicker').maxDate(e.date);
  });
  delayedTillDateTimePicker.on('dp.change', function(e) {
    startAtDateTimePicker.data('DateTimePicker').minDate(e.date);
    endAtDateTimePicker.data('DateTimePicker').minDate(e.date);
  });

  var initalValue = $('#contest_contest_type').val();
  // select different group based on judge type
  $('.time-setting').each(function(_, v) {
    if ($(v).data('type').split(' ').indexOf(initalValue) !== -1) {
      $(this).removeClass('hidden');
    } else {
      $(this).addClass('hidden');
    }
  });
  $('#contest_contest_type').on('change', function() {
    var selectedValue = $(this).val();
    $('.time-setting').each(function(_, v) {
      if ($(v).data('type').split(' ').indexOf(selectedValue) !== -1) {
        $(this).removeClass('hidden');
      } else {
        $(this).addClass('hidden');
      }
    });
  });

  var problemsDescription = $('.contest-problem-list .panel');
  $('#solution_problem_id').select2({
    templateResult: function(state) {
      if (!state.id) { return state.text; }
      var $state = $(
          '<div><h4>' + state.text + '</h4><span>' + '<span>' +
          $(problemsDescription[state.id]).data('blurb') + '</span></div>'
      );
      return $state;
    }
  });
  $('#contest_contest_problem_ids').select2({
    ajax: {
      url: "/query?type_filter=problem&search_for_id=true",
      dataType: 'json',
      delay: 250,
      data: function(params) {
        return {
          term: params.term
        };
      },
      processResults: function(data) {
        console.log(data.problems);
        return {
          results: data.problems
        };
      },
      cache: true
    },
    escapeMarkup: function (markup) { return markup; },
    minimumInputLength: 1,
    placeholder: 'Search to add a new problem',
    templateResult: function(state) {
      var $state = $(
          '<div><h4>' + state.title + '</h4><span>' + '<span>' +
          state.description_blurb + '</span></div>'
      );
      return $state;
    },
    templateSelection: function(state) {
      if (state.text) return state.text;
      return state.title;
    }
  });
};

$(document).ready(ready);
$(document).on('page:load', ready);
