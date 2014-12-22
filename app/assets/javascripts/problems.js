$(document).on('page:change', function() {

  initalValue = $('#problem_judge_type').val();

  $('.judge-source-group').each(function(_, v) {
    if ($(v).data('type') === initalValue) {
      $(this).removeClass('hidden');
    } else {
      $(this).addClass('hidden');
    }
  });

  $('#problem_judge_type').on('change', function() {
    var selectedValue = $(this).val();
    $('.judge-source-group').each(function(_, v) {
      if ($(v).data('type') === selectedValue) {
        $(this).removeClass('hidden');
      } else {
        $(this).addClass('hidden');
      }
    });
  });

});
