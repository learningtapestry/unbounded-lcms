(function(window, Unbounded) {  
  var PreviewTemplate;

  function getPlacementFn(defaultPosition, width, height) {
    return function (tip, element) {
      var position, top, bottom, left, right;

      var $element = $(element);
      var boundTop = $(document).scrollTop();
      var boundLeft = $(document).scrollLeft();
      var boundRight = boundLeft + $(window).width();
      var boundBottom = boundTop + $(window).height();

      var pos = $.extend({}, $element.offset(), {
        width: element.offsetWidth,
        height: element.offsetHeight
      });

      var isWithinBounds = function (elPos) {
        return boundTop < elPos.top && boundLeft < elPos.left && boundRight > (elPos.left + width) && boundBottom > (elPos.top + height);
      };

      var testTop = function () {
        if (top === false) return false;
        top = isWithinBounds({
            top: pos.top - height,
            left: pos.left + pos.width / 2 - width / 2
        });
        return top ? "top" : false;
      };

      var testBottom = function () {
        if (bottom === false) return false;
        bottom = isWithinBounds({
            top: pos.top + pos.height,
            left: pos.left + pos.width / 2 - width / 2
        });
        return bottom ? "bottom" : false;
      };

      var testLeft = function () {
        if (left === false) return false;
        left = isWithinBounds({
            top: pos.top + pos.height / 2 - height / 2,
            left: pos.left - width
        });
        return left ? "left" : false;
      };

      var testRight = function () {
        if (right === false) return false;
        right = isWithinBounds({
            top: pos.top + pos.height / 2 - height / 2,
            left: pos.left + pos.width
        });
        return right ? "right" : false;
      };

      switch (defaultPosition) {
        case "top":
            if (position = testTop()) return position;
        case "bottom":
            if (position = testBottom()) return position;
        case "left":
            if (position = testLeft()) return position;
        case "right":
            if (position = testRight()) return position;
        default:
            if (position = testTop()) return position;
            if (position = testBottom()) return position;
            if (position = testLeft()) return position;
            if (position = testRight()) return position;
            return defaultPosition;
      }
    };
  }

  function initializePopover($elm) {
    $('.popover').popover('hide');
    var popover = $elm.data('bs.popover');
    if (!popover) {
      $elm.popover({
        html: true,
        content: I18n.t('ui.loading'),
        template: $('#popover-template').html(),
        container: 'body',
        placement: getPlacementFn('right', 450, 300)
      }).popover('show');
    }
  }

  function openPopover($elm, data) {
    data.highlights = Unbounded.highlights.findHighlights($elm.data('resource-id'));
    data.alignmentsTitle = I18n.t('title.alignments');
    data.curriculum_context = $elm.parents('.math').length ? 'math' : 'ela';
    var popover = $elm.data('bs.popover');
    $elm.attr('data-original-title', data.resource_preview.title);
    popover.options.content = PreviewTemplate(data);
    popover.options.title = data.resource_preview.title;
    popover.$tip.find('h3').show();
    popover.show();
  }

  function initializePreviews() {
    PreviewTemplate = _.template($('#resource-preview-template')[0].innerHTML);

    $('[data-resource-id]')
      .mouseenter(function() {
        var $this = $(this);
        initializePopover($this);
        $.ajax({
          dataType: 'json',
          url: Routes.resource_preview_path({ id: $this.data('resource-id') }),
          success: function(data) {
            if ($this.is(':hover')) {
              openPopover($this, data);
            }
          }
        });
      })
      .mouseleave(function(e) {
        e.stopPropagation();
        var $this = $(this);
        setTimeout(function () {
          if (!$('.popover:hover').length) { 
            $this.popover('hide');
          }
        }, 50);
      });

    $(document).on('mouseleave', '.popover', function () {
      $('.popover').popover('hide');
    });
  }

  Unbounded.initializePreviews = initializePreviews;
})(window, Unbounded);
