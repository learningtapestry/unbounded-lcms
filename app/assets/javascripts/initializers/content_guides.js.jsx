$(function () {

  let lastScrollTop = 0;
  const SCROLLING_THRESHOLD = 15;

  function initSticky() {
    let $sidebar = $('#cg-sidebar');
    let elem = new Foundation.Sticky($sidebar,
                                    { checkEvery: 50,
                                      stickyOn: 'small',
                                      anchor: 'c-ch-content'
                                    });
    $(window).trigger('load.zf.sticky');
    $(window).off('sticky.zf.unstuckfrom:top').on('sticky.zf.unstuckfrom:top', () => {
      $('#cg-sidebar-container').addClass('o-sidebar--tiny');
    });
  }

  function initTasksToggler() {
    $('.c-cg-task__toggler').click(function() {
      $('.c-cg-task__hidden', $(this).parent()).toggle();
      $('.c-cg-task__toggler__hide', $(this)).toggle();
      $('.c-cg-task__toggler__show', $(this)).toggle();
    });
  }

  function updateMenu(headings) {
    let index = _.findLastIndex(headings, function(heading) {
      return heading.getBoundingClientRect().bottom < 50;
    });
    let heading = headings[index];

    $('.o-sidebar-nav .active').removeClass('active');
    $('.o-sidebar-nav__item').removeClass('expanded');

    if (heading) {
      var $item = $('.o-sidebar-nav__item a[href="#' + heading.id + '"]');
      $item.addClass('active').addClass('expanded');
      $item.parents('.o-sidebar-nav__item').addClass('expanded');
    }
  }

  function updateModalMenu() {
    let $targets = $('li.expanded > ul.nested');
    $('#cg-menu-modal').foundation('down', $targets);
  }

  function updateSticky(headings) {
    if (!$('#cg-sidebar.is-stuck').length) return;
    let $sticky = $('#cg-sidebar-xs'),
        $stickyContainer = $('#cg-sidebar-container'),
        $modal = $('#cg-contents-modal');
    const st = $(document).scrollTop();
    if (st < lastScrollTop - SCROLLING_THRESHOLD) {
      $stickyContainer.removeClass('o-sidebar--tiny');
      $sticky.addClass('o-sidebar-xs--show');
      $('#cg-sidebar-xs__action').unbind().click((e) => {
        e.preventDefault();
        updateMenu(headings);
        updateModalMenu();
        $sticky.removeClass('o-sidebar-xs--show');
        $modal.foundation('open');
      });
      $('#cg-menu-modal .o-sidebar-nav__item__content').unbind().click((e) => {
        $sticky.removeClass('o-sidebar-xs--show');
        $stickyContainer.addClass('o-sidebar--tiny');
        $modal.foundation('close');
      });
    }
    if (st > lastScrollTop + SCROLLING_THRESHOLD) {
      $sticky.removeClass('o-sidebar-xs--show');
      $stickyContainer.addClass('o-sidebar--tiny');
    }
    lastScrollTop = st;
  }

  function handleScroll(headings, e) {
    if (Foundation.MediaQuery.atLeast('ipad')) {
      lastScrollTop = 0;
      updateMenu(headings);
    } else {
      updateSticky(headings);
    }
  }

  window.initializeContentGuide = function() {
    if (!$('.o-page--cg').length) return;
    const headings = $.makeArray($('.c-cg-heading'));
    initSticky();
    initTasksToggler();
    updateMenu(headings);
    $('#cg-page').off('scrollme.zf.trigger').on('scrollme.zf.trigger', handleScroll.bind(this, headings));
  }

})
