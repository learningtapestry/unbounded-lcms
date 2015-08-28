// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(function() {
  $(document).on('click', '.lobject-node-opener', function() {
    $(this).parent().find('> ul').toggle();
  });

  function closeNodes() {
    $('.lobject-node')
      .not($('.you-are-here').parents('li'))
      .find('.lobject-node-opener').each(function() {
        $(this).parent().find('> ul').hide();
      });
  }

  $(document).on('page:change', function() {
    closeNodes();
  });

  closeNodes();
});
