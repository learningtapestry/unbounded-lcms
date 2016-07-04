(function($) {

  $.fn.smoothscrolling = function(fnScrollingState=null) {
    this.find('a[href^="#"], div[href^="#"]').on('click', function(event) {
      var target = $(event.target.attributes.href ? event.target.attributes.href.value : event.target.parentElement.attributes.href.value);
      if( target.length ) {
        event.preventDefault();
        if (fnScrollingState) fnScrollingState(true);
        $('html, body').animate({ scrollTop: target.offset().top }, 500)
                       .promise()
                       .always(() => { if (fnScrollingState) fnScrollingState(false); });
      }
    });
    return this;
  };

})(jQuery);
