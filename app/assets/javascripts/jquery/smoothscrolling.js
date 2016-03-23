(function($) {

  $.fn.smoothscrolling = function() {
    this.find('a[href^="#"]').on('click', function(event) {
      var target = $(event.target.attributes.href.value);
      if( target.length ) {
        event.preventDefault();
        $('html, body').animate({ scrollTop: target.offset().top }, 500);
      }
    });
    return this;
  };

})(jQuery);
