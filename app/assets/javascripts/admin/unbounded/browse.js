// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(function() {
  $(document).on('click', '.resource-node-opener', function() {
    $(this).parent().find('> ul').toggle();
  });

  function closeNodes() {
    $('.resource-node')
      .not($('.you-are-here').parents('li'))
      .find('.resource-node-opener').each(function() {
        $(this).parent().find('> ul').hide();
      });
  }

  $(document).on('page:change', function() {
    closeNodes();
  });

  closeNodes();
});
