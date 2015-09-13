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
    isAllowed: function(current, hint, target) {
      var currentDeleted = $(current).parents('.deleted').length > 0;
      var targetDeleted  = $(target).parents('.deleted').length > 0;

      if (currentDeleted || targetDeleted) {
        hint.css('background-color', '#ff9999');
        return false;
      }

      return true;
    },    
    placeholderCss: {
      'background-color': 'yellow'
    }
  });

  $('.add-link').click(function() {
    var $parent = $(this).closest('li');
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

  $('.delete-link').click(function() {
    var $parent = $(this).closest('li');
    $parent.addClass('deleted');
    $('.destroy', $parent).val(1);
    return false;
  });

  $('.restore-link').click(function() {
    var $parent = $(this).closest('li');
    $parent.removeClass('deleted');
    $('.destroy', $parent).val(0);
    return false;
  });
};
