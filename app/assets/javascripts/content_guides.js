window.initializeContentGuide = function() {
  var $contengGuide = $('.o-page--cg');

  if ($contengGuide.length > 0) {
    var headings = $.makeArray($('.c-cg-heading'));

    var updateMenu = function() {
      var index = _.findLastIndex(headings, function(heading) {
        return heading.getBoundingClientRect().bottom < 50;
      });
      var heading = headings[index];

      $('.o-sidebar-nav .active').removeClass('active');
      $('.o-sidebar-nav__item > .o-sidebar-nav').hide();

      if (heading) {
        var $item = $('.o-sidebar-nav__item a[href="#' + heading.id + '"]');
        $item.addClass('active');
        $item.parents('.o-sidebar-nav__item').each(function(_, item) {
          $('.o-sidebar-nav:first', $(item)).show();
        });
      }
    };

    updateMenu();
    $(window).scroll(updateMenu);

    $('.c-cg-task__toggler').click(function() {
      $('.c-cg-task__hidden', $(this).parent()).toggle();
      $('.c-cg-task__toggler__hide', $(this)).toggle();
      $('.c-cg-task__toggler__show', $(this)).toggle();
    });
  }
}
