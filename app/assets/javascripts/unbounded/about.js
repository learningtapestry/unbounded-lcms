$(function() {
  $('.aboutPage__member__label').click(function() {
    var $toggle = $(this).parent().find('.aboutPage__member__toggle');
    $toggle.prop('checked', !$toggle.prop('checked'));
    return false;
  });
});
