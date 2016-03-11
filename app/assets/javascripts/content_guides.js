window.initializeContentGuide = function() {
  var originalLeave = $.fn.popover.Constructor.prototype.leave;

  $.fn.popover.Constructor.prototype.leave = function(obj) {
    var self = obj instanceof this.constructor ? obj : $(obj.currentTarget)[this.type](this.getDelegateOptions()).data('bs.' + this.type);
    var container, timeout;

    originalLeave.call(this, obj);

    if (obj.currentTarget) {
      container = $(obj.currentTarget).siblings('.popover');
      timeout = self.timeout;
      container.one('mouseenter', function() {
        //We entered the actual popover – call off the dogs
        clearTimeout(timeout);
        //Let's monitor popover content instead
        container.one('mouseleave', function() {
          $.fn.popover.Constructor.prototype.leave.call(self, self);
        });
      });
    }
  };

  var $contengGuide = $('.contengGuide');

  if ($contengGuide.length > 0) {
    $('.contengGuide__nav').sticky({ bottomSpacing: $('body').height() - $contengGuide.height() - $contengGuide.offset().top });

    $('.contengGuide__keyword').popover({
      content: function() {
        return $(this).data('description');
      },
      delay: { hide: 500 },
      html: true,
      placement: 'top',
      trigger: 'hover'
    });

    $('.contengGuide__task__toggler').click(function() {
      $('.contengGuide__task__hidden', $(this).parent()).toggle();
      return false;
    });

    $('a[href^="#ftnt"]:not([href^="#ftnt_ref"])').popover({
      content: function() {
        var $this = $(this);
        var sel = $this.attr('href');
        var $link = $(sel);
        var $footnote = $link.closest('div').clone();
        $footnote.find('a[href^="#ftnt_ref"]').remove();
        console.log($footnote.html());
        return $footnote.html();
      },
      delay: { hide: 500 },
      html: true,
      placement: 'top',
      trigger: 'hover'
    })
  }  
}
