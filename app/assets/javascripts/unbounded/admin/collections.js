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
    placeholderCss: {
      'background-color': 'yellow'
    }
  });
};
