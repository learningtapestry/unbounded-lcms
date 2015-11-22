window.initializeSearchForm = function() {
  $('.searchForm__limit').change(function() {
    $('.searchForm input[name="limit"]').val(this.value);
    $('.searchForm').submit();
  });

  $('.searchForm__subjectRadio').change(function() {
    if ($(this).data('subject') == 'ela') {
      $('.searchForm__gradeLabel__elaTitle').show();
      $('.searchForm__gradeLabel__mathTitle').hide();
    }

    if ($(this).data('subject') == 'math') {
      $('.searchForm__gradeLabel__elaTitle').hide();
      $('.searchForm__gradeLabel__mathTitle').show();
    }
  });
}
