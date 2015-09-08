window.initializeTree = function() {
  $('.editable-tree').sortableLists({
    complete: function(e) {
      var $e = $(e);
      var $parentList = $e.parent();
      var $parentNode = $parentList.parent();

      // Set parent ID
      var parentID = $('.child-id', $parentNode).val();
      $('> .parent-id', $e).val(parentID);

      // Update positions
      $('> .lobject-node .position', $parentList).each(function(i, e) {
        $(e).val(i + 1);
      });
    },
    hintCss: {
      'background-color':'green',
      'border':'1px dashed white'
    },
    ignoreClass: 'clickable',
    placeholderCss: {
      'background-color': 'yellow'
    }
  });

  $('.add-child').click(function() {
    var $parent = $(this).parent();
    // Set parent ID
    $('#new-child-parent-id').val($parent.data('id'));
    // Set position
    var positions = $('> ul li', $parent).map(function() {
      return parseInt($('> .position', $(this)).val()) || 0;
    });
    var position = positions.length > 0 ? Math.max.apply(Math, positions) + 1 : 0;
    $('#new-child-position').val(position);
    // Show form
    $('#add-child-modal').modal('show');
    return false;
  });
};
