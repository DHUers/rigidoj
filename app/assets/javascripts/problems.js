var ready = function() {

  var initalValue = $('#problem_judge_type').val();

  // select different group based on judge type
  $('.judge-vendor-group').each(function(_, v) {
    if ($(v).data('type').split(' ').indexOf(initalValue) !== -1) {
      $(this).removeClass('hidden');
    } else {
      $(this).addClass('hidden');
    }
  });
  $('#problem_judge_type').on('change', function() {
    var selectedValue = $(this).val();
    $('.judge-vendor-group').each(function(_, v) {
      if ($(v).data('type').split(' ').indexOf(selectedValue) !== -1) {
        $(this).removeClass('hidden');
      } else {
        $(this).addClass('hidden');
      }
    });
  });

  var addNewJudgerConfigurationButton = $('#add-new-judger-configuration'),
      judgerConfiguration = $('.jugder-configuration');
  addNewJudgerConfigurationButton.on('click', function() {
    var config = $('.limit-group:first').clone();
    config.removeClass('limit-group').addClass('additional-limit-group');
    config.find('.platform span').prop('contenteditable', true);
    config.append('<div class="col-md-1"><button class="btn btn-default" type="button"> -</button></div>');
    config.appendTo(judgerConfiguration);
  });

  // extract additional limit group when submit
  $('.limit-group').closest('form').submit(function() {
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

  // delegate delete event
  $('.jugder-configuration').on('click', 'button', function(e) {
    $(this).closest('.additional-limit-group').remove();
  });

};

$(document).ready(ready);
$(document).on('page:load', ready);
