$(function() {
  $('.aboutPage__member__close').click(function() {
    $(this).parent().find('.aboutPage__member__toggle').prop('checked', false);
    return false;
  });
});
