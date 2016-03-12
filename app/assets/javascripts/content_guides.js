window.initializeContentGuide = function() {
  var $contengGuide = $('.o-page--cg');

  if ($contengGuide.length > 0) {
    $('.c-cg-task__toggler').click(function() {
      $('.c-cg-task__hidden', $(this).parent()).toggle();
      return false;
    });
  }  
}
