ready(function() {
  var filter = $('.c-admcur-filter');
  filter.find('select').change(function(e) {
    filter.submit();
  });
});
