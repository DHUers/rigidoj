var ready = function() {
  smoothScroll.init({
    speed: 500,
    offset: 20,
    easing: 'easeOutQuart'
  });

  $('.datetimepicker').each(function() {
    $(this).datetimepicker({
      format: 'YYYY-MM-DD HH:mm'
    });
  });
  var startAtDateTimePicker = $('#started-at-datetimepicker'),
      endAtDateTimePicker = $('#end-at-datetimepicker'),
      delayedTillDateTimePicker = $('#delayed-till-datetimepicker'),
      frozenRankingFromDateTimePicker = $('#frozen-ranking-from-datetimepicker');
  startAtDateTimePicker.on('dp.change', function(e) {
    endAtDateTimePicker.data('DateTimePicker').minDate(e.date);
    delayedTillDateTimePicker.data('DateTimePicker').minDate(e.date);
    frozenRankingFromDateTimePicker.data('DateTimePicker').minDate(e.date);
  });
  endAtDateTimePicker.on('dp.change', function(e) {
    startAtDateTimePicker.data('DateTimePicker').maxDate(e.date);
    delayedTillDateTimePicker.data('DateTimePicker').minDate(e.date);
    frozenRankingFromDateTimePicker.data('DateTimePicker').maxDate(e.date);
  });
  delayedTillDateTimePicker.on('dp.change', function(e) {
    startAtDateTimePicker.data('DateTimePicker').minDate(e.date);
    endAtDateTimePicker.data('DateTimePicker').minDate(e.date);
  });

  var initalValue = $('#contest-type').val() || 'normal';
  // select different group based on judge type
  $('.time-setting').each(function(_, v) {
    if ($(v).data('type').split(' ').indexOf(initalValue) !== -1) {
      $(this).removeClass('hidden');
    } else {
      $(this).addClass('hidden');
    }
  });
  $('#contest-type').on('change', function() {
    var selectedValue = $(this).val() || 'normal';
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

  var contestProblemList = $('#contest-problem-ids');
  contestProblemList.select2({
    width: '100%',
    ajax: {
      url: Rigidoj.BASE_URL + "/query?type_filter=problem&search_for_id=true",
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
    $.notify({
      // options
      message: 'Submit succeed'
    }, {
      type: 'success',
      delay: 3000,
      animate: {
        enter: 'animated fadeInDown',
        exit: 'animated fadeOutUp'
      }
    });
  }).on('ajax:error', function(e, xhr, status, error) {
    response = JSON.parse(xhr.responseText);
    content = ''
    $.each(response['errors'], function() {
      content += '<p>' + this + '</p>'
    });
    $.notify({
      // options
      title: 'Submit error occurs',
      message: content
    }, {
      type: 'danger',
      delay: 3000,
      animate: {
        enter: 'animated fadeInDown',
        exit: 'animated fadeOutUp'
      }
    });
  });

  $('#contest-group-ids').select2({
    width: '100%',
    placeholder: 'Visible to all'
  });

  $('.timeframe-group').each(function() {
    var ele = $(this),
        unix = ele.find('time').data('unix');
    ele.attr('title', moment.unix(unix).fromNow());
  }).tooltip();

  $('#judger-group').select2({
    width: '100%',
    placeholder: "Choose a group",
    allowClear: true
  });

  var rankTable = $('#ranking-table'),
      contestEndAt = rankTable.data('end-minute'),
      contestProblemCount = rankTable.data('problem-count'),
      minSolvedTime = -1,
      solvedAt,
      solutionStat;

  for (var i = 0; i < contestProblemCount; i++) {
    minSolvedTime = Math.min.apply(Math, rankTable.find('.problem-' + i).map(function() {
      return $(this).data('solved-at');
    }).get());
    if (isFinite(minSolvedTime)) { // get a min value
      rankTable.find('.problem-' + i).each(function() {
        solutionStat = $(this);
        solvedAt = solutionStat.data('solved-at');
        if (solvedAt == minSolvedTime) {
          solutionStat.addClass('first-solved');
        }
        if (solvedAt >= contestEndAt) {
          solutionStat.addClass('delayed');
        }
      });
    }
  }
};
$(document).on('ready page:load', ready);
