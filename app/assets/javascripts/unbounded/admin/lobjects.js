window.initializeLobjectList = function() {
  $('.lobject-list-select-all').click(function() {
    $('.lobject-checkbox').prop('checked', $(this).prop('checked'));
  });
};
