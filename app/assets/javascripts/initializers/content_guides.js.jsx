$(function () {

  let lastScrollTop = 0;
  let isScrolling = false;
  const SCROLLING_THRESHOLD = 15;

  function clearStates() {
    lastScrollTop = 0;
    isScrolling = false;
  }

  function initSticky() {
    let $sidebar = $('#cg-sidebar');
    let elem = new Foundation.Sticky($sidebar,
                                    { checkEvery: 50,
                                      stickyOn: 'small',
                                      anchor: 'c-ch-content'
                                    });
    $(window).trigger('load.zf.sticky');
    $(window).off('sticky.zf.unstuckfrom:top').on('sticky.zf.unstuckfrom:top', () => {
      handleSidebarMenuHide();
      clearStates();
    });
  }

  function initTopScrollButton() {
    $(window).scroll(function() {
      if ( $(window).scrollTop() > 300 ) { /* amound scrolled */
        $('.o-top-scroll-button').fadeIn('slow');
      } else {
        $('.o-top-scroll-button').fadeOut('slow');
      }
      });
      $('.o-top-scroll-button').click(function() {
        $('html, body').animate({ scrollTop: 0 }, 700);
        return false;
    });
  }

  function initTasksToggler() {
    $('.c-cg-task__toggler').click(function() {
      $('.c-cg-task__hidden', $(this).parent()).toggle();
      $('.c-cg-task__toggler__hide', $(this)).toggle();
      $('.c-cg-task__toggler__show', $(this)).toggle();
    });
  }

  function handleSidebarMenuShow() {
    $('#cg-sidebar-xs').addClass('o-sidebar-xs--show');
    $('#cg-sidebar-container').removeClass('o-sidebar--tiny');
  }

  function handleSidebarMenuHide() {
    $('#cg-sidebar-xs').removeClass('o-sidebar-xs--show');
    $('#cg-sidebar-container').addClass('o-sidebar--tiny');
  }

  function updateMenu(headings) {
    let topHeader = $('#cg-sidebar-xs').outerHeight(true);
    let index = _.findLastIndex(headings, function(heading) {
      return heading.getBoundingClientRect().bottom < (50 + topHeader);
    });
    let heading = headings[index];

    $('.o-sidebar-nav .active').removeClass('active');
    $('.o-sidebar-nav__item').removeClass('expanded');

    if (heading) {
      var $item = $('.o-sidebar-nav__item [href="#' + heading.id + '"]');
      $item.addClass('active').addClass('expanded');
      $item.parent('a').addClass('active');
      $item.parents('.o-sidebar-nav__item').addClass('expanded');
    }
  }

  function updateModalMenu() {
    let $targets = $('li.expanded > ul.nested');
    $('#cg-menu-modal').foundation('down', $targets);
  }

  function updateSticky(headings) {
    if (isScrolling || !$('#cg-sidebar.is-stuck').length) return;
    const st = $(document).scrollTop();
    if (st < lastScrollTop - SCROLLING_THRESHOLD) {
      handleSidebarMenuShow();
      $('#cg-sidebar-xs__action').unbind().click((e) => {
        e.preventDefault();
        updateMenu(headings);
        updateModalMenu();
        handleSidebarMenuHide();
        $('#cg-contents-modal').foundation('open');
      });
    }
    if (st > lastScrollTop + SCROLLING_THRESHOLD) {
      handleSidebarMenuHide();
    }
    lastScrollTop = st;
  }

  function handleScroll(headings, e) {
    if (Foundation.MediaQuery.atLeast('ipad')) {
      clearStates();
      updateMenu(headings);
    } else {
      updateSticky(headings);
    }
  }

  function setScrollingState(state) {
    isScrolling = state;
    lastScrollTop = $(document).scrollTop();
    handleSidebarMenuHide();
    $('#cg-contents-modal').foundation('close');
  }

  window.initializeContentGuide = function() {
    if (!$('.o-page--cg').length) return;
    const headings = $.makeArray($('.c-cg-heading'));
    clearStates();
    initSticky();
    initTopScrollButton();
    initTasksToggler();
    updateMenu(headings);
    $('.o-page--cg, #cg-contents-modal').smoothscrolling(setScrollingState);
    $('#cg-page').off('scrollme.zf.trigger').on('scrollme.zf.trigger', handleScroll.bind(this, headings));
  }

})
