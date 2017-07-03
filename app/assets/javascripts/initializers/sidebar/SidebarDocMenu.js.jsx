/*
 * TODO: Keep 2 classes for sidebar menu for ld&cg till cg refactoring
 */
class SidebarDocMenu {
  constructor() {
    this.headings = $.makeArray($('.c-ld-toc'));
    this.clsPrefix = prefix;
    this._initToggler();
    this._updateMenu();
  }

  handleUpdate(e) {
    switch(e) {
      case EVENTS.MOBILE_SHOW_MENU:
      case EVENTS.UPDATE_MENU:
        this._updateMenu();
        break;
      case EVENTS.SCROLLING:
        this._showShowAll();
        break;
    }
  }

  _initToggler() {
    this.bExpanded = false;
    $('.o-ld-sidebar-header__toggle--show').click(() => {
      $('.o-ld-sidebar__item').addClass('o-ld-sidebar__item--expanded');
      this._showHideAll();
    });
    $('.o-ld-sidebar-header__toggle--hide').click(() => {
      $('.o-ld-sidebar__item').removeClass('o-ld-sidebar__item--expanded');
      this._showShowAll();
    });
    $('.o-ld-sidebar-item__icon').click((e) => {
      const $item = $(e.target).closest('.o-ld-sidebar__item');
      $item.toggleClass('o-ld-sidebar__item--expanded');
      if ($item.is('.o-ld-sidebar__item--expanded')) {
        $item.children('.o-ld-sidebar__menu').children('.o-ld-sidebar__item').addClass('o-ld-sidebar__item--expanded');
      } else {
        $item.find('.o-ld-sidebar__item').removeClass('o-ld-sidebar__item--expanded');
      }

    });
  }

  _updateMenu() {
    const topHeader = $('#ld-sidebar-xs').outerHeight(true) || 0;
    const index = _.findLastIndex(this.headings, (heading) => {
      return heading.getBoundingClientRect().bottom < (50 + topHeader);
    });
    const heading = this.headings[index];

    $('.o-ld-sidebar__item--active').removeClass('o-ld-sidebar__item--active');
    if (!this.bExpanded) $('.o-ld-sidebar__item--expanded').removeClass('o-ld-sidebar__item--expanded');

    if (heading) {
      const $item = $('.o-ld-sidebar__item [href="#' + heading.id + '"]');
      $item.parents('.o-ld-sidebar__item')
           .addClass('o-ld-sidebar__item--expanded')
           .addClass('o-ld-sidebar__item--active');
      $item.closest('.o-ld-sidebar__menu--nested').siblings('.o-ld-sidebar__item')
           .addClass('o-ld-sidebar__item--expanded');
    }
  }

  _showHideAll() {
    this.bExpanded = true;
    $('.o-ld-sidebar-header__toggle--show').hide();
    $('.o-ld-sidebar-header__toggle--hide').show();
  }

  _showShowAll() {
    this.bExpanded = false;
    $('.o-ld-sidebar-header__toggle--show').show();
    $('.o-ld-sidebar-header__toggle--hide').hide();
  }
}
