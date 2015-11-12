$(function() {
  $('.aboutPage__member__label').click(function() {
    var $member = $(this).parent();
    if ($member.hasClass('active')) {
      $member.removeClass('active');
    } else {
      $('.aboutPage__member').removeClass('active');
      $member.addClass('active');
    }
  });
});
