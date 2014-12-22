$(document).on('page:change', function() {

  $('#problem_judge_type').on('change', function() {
    var selectedValue = $(this).val();
    $('.judge-source-group').each(function(i) {
      if (i == selectedValue) {
        $(this).removeClass('hidden');
      } else {
        $(this).addClass('hidden');
      }
    });
  });

});
