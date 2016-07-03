$(function () {

  let $elDropdown = null;

  function initDropdown() {
    if ($elDropdown == null) {
      $elDropdown = $('.c-header__left-menu');
      new Foundation.DropdownMenu($elDropdown);
    }
  }

  function destroyDropdown() {
    if ($elDropdown) {
      $elDropdown.foundation('destroy');
      $elDropdown.find('.c-header__submenu').removeClass('vertical');
      $elDropdown = null;
    }
  }

  function handleDropdown() {
    if (Foundation.MediaQuery.atLeast('large')) {
      initDropdown();
    } else {
      destroyDropdown();
    }
  }

  function handleResize(event, newSize, oldSize) {
    handleDropdown();
  }

  window.initializeHeaderDropdown = function() {
    if (!$('.c-header__left-menu').length) return;
    $elDropdown = null;
    handleDropdown();
    $(window).off('changed.zf.mediaquery.ubheader').on('changed.zf.mediaquery.ubheader', handleResize);
  }

})
