$('#problem-listings tbody').on('click', 'tr', function() {
  window.location = $(this).find('a').attr('href');
});
