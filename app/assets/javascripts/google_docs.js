window.initializeGoogleDoc = function() {
  if ($('.googleDoc').length > 0) {
    $('.googleDoc__nav').sticky();

    $('a[href^="#ftnt"]:not([href^="#ftnt_ref"])').popover({
      content: function() {
        var $this = $(this);
        var sel = $this.attr('href');
        var $link = $(sel);
        var $footnote = $link.closest('div').clone();
        $footnote.find('a[href^="#ftnt_ref"]').remove();
        return $footnote.html();
      },
      html: true,
      placement: 'top',
      trigger: 'hover'
    })
  }  
}
