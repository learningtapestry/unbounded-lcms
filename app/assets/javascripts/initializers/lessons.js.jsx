$(function () {
  const COMPONENT_PREFIX = '.o-ld';

  function initPdToggler() {
    let prefix = `${COMPONENT_PREFIX}-pd`;
    $(`${prefix}-toggler`).click(function() {
      $(this)
        .closest(prefix)
        .toggleClass(`o-ld-pd--collapsed o-ld-pd--expanded`)
        .find('.o-ld-pd__description')
        .toggleClass('o-ld-pd__description--hidden');

      $(this)
        .find('i')
        .toggleClass('fa-expand fa-compress');
    });
  }

  function initSidebar() {
    const observers = [
      new SidebarDocMenu(),
      new TopScroll(),
      new SidebarSticky(),
    ];
    let sidebar = new SideBar(observers, { clsPrefix: 'ld', breakPoint: 'large', bHandleMobile: false });
  }

  function initToggler(component) {
    let prefix = `${COMPONENT_PREFIX}-${component}`;
    $(`${prefix}__toggler`).click(function() {
      $(`${prefix}__content--hidden`, $(this).parent()).toggle();
      $(`${prefix}__toggler--hide`, $(this)).toggle();
      $(`${prefix}__toggler--show`, $(this)).toggle();
    })
  }

  window.initializeLessons = function() {
    if (!$('.o-page--ld').length) return;
    initPdToggler();
    initSidebar();
    initToggler('expand');
    initToggler('materials');
  }
});
