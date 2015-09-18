window.addTag = function(name, value, text) {
  $select = $('#' + name + '_select').selectize();
  selectize = $select[0].selectize;
  selectize.addOption({ text: text, value: value });
  selectize.addItem(value);
  $('#' + name + '_modal').modal('hide');
};

window.initializeLobjectForm = function() {
  $('.create-tag').click(function() {
    var name = $(this).data('name');
    $modal = $('#' + name + '_modal');
    $input = $modal.find('input.string');
    $input.val('');
    $modal.modal('show');
    $input.focus();
    return false;
  });
};

window.showTagError = function(name, message) {
  $error = $('#' + name + '_modal').find('.error');
  $error.html(message);
  $error.addClass('alert alert-danger');
};
