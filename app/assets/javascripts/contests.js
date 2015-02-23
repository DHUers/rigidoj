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

  $('#submit-solution').on('show.bs.modal', function(e) {
    var problemsDescription = $('.problem-panel'),
        position = 0;
    $('.nav.problem-list li').each(function(i) {
      if (i > 0 && $(this).hasClass('active')) { position = i-1; }
    });
    $('#solution_contest_problem_id').select2({
      width: '100%',
      templateResult: function(state) {
        if (!state.id) { return state.text; }
        var $state = $(
            '<div><h4>' + state.text + '</h4><span>' + '<span>' +
            $(problemsDescription[state.id]).data('blurb') + '</span></div>'
        );
        return $state;
      }
    }).val(position).trigger('change');
    $('#solution_platform').select2({width: '100%'});
  });

  var contestProblemList = $('#contest_problem_ids');
  contestProblemList.select2({
    width: '100%',
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
    templateSelection: function(selection) {
      if (selection.text) selection.title = selection.text;
      return selection.title;
    }
  });

  if (contestProblemList.data('select2')) {
    contestProblemList.data('select2').$container.find('ul').sortable()
        .closest('form').on('submit', function (e) {
          // get all sorts of information from the original option list
          // and store its position accordingly
          // TODO: remove this if select2 4.0 support the sorting
          var select = $(contestProblemList[0]),
              list = contestProblemList.data('select2').$container.find('ul li.select2-selection__choice'),
              problemID = {};
          // get the problem id <> title mapping from dom
          select.find('option').each(function () {
            var element = $(this),
                text = element.prop('title') || element.text();
            // inserted option is different from outputed by rails
            // so it may be in title or in text.
            problemID[text.trim()] = element.prop('value');
          });
          select.empty();
          // insert the option tag for sorting
          list.each(function () {
            select.append('<option selected="selected" value="' +
            problemID[this.title.trim()] + '"></option>');
          });
        });
  }

  $('body').scrollspy({
    target: '.action-list',
    offset: 80
  });

  $('#submit-solution form').submit(function() {
    $('#submit-solution').modal('hide');
    // TODO: reject blank input
//    if (ace.edit('solution_source').getSession().getValue().length <= 0) {
//      Rigidoj.Utilities.showFlyInMessage('Submission error', '<p>No source</p>', 'danger');
 //     return false;
 //   };
  }).on('ajax:success', function(e, data, status, xhr) {
    Rigidoj.Utilities.showFlyInMessage('Submit succeed', '', 'success', 2000);
  }).on('ajax:error', function(e, xhr, status, error) {
    response = JSON.parse(xhr.responseText);
    content = ''
    $.each(response['errors'], function() {
      content += '<p>' + this + '</p>'
    });
    Rigidoj.Utilities.showFlyInMessage('Submission error', content, 'danger');
  });
};

$(document).ready(ready);
$(document).on('page:load', ready);
