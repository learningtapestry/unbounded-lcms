(function(window, Unbounded) {  
  var PreviewTemplate;

  function initializePopover($elm) {
    $('.popover').popover('hide');
    var popover = $elm.data('bs.popover');
    if (!popover) {
      $elm.popover({
        html: true,
        content: I18n.t('ui.loading'),
        template: $('#popover-template').html()
      }).popover('show');
    }
  }

  function openPopover($elm, data) {
    data.highlights = Unbounded.highlights.findHighlights($elm.data('lobject-id'));
    data.alignmentsTitle = I18n.t('unbounded.title.alignments')
    var popover = $elm.data('bs.popover');
    popover.options.content = PreviewTemplate(data);
    popover.options.title = data.title;
    popover.show();
  }

  function initializePreviews() {
    PreviewTemplate = _.template($('#resource-preview-template')[0].innerHTML);

    $('[data-lobject-id]')
      .mouseenter(function() {
        var $this = $(this);
        initializePopover($this);
        $.ajax({
          dataType: 'json',
          url: Routes.unbounded_resource_preview_path({ id: $this.data('lobject-id') }),
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
