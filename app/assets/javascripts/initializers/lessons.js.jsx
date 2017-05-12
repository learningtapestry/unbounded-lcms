$(function () {
  const COMPONENT_PREFIX = '.o-ld';

  function initToggler(component) {
    let prefix = `${COMPONENT_PREFIX}-${component}`;
    $(`${prefix}__toggler`).click(function() {
      $(`${prefix}__content--hidden`, $(this).parent()).toggle();
      $(`${prefix}__toggler--hide`, $(this)).toggle();
      $(`${prefix}__toggler--show`, $(this)).toggle();
    })
  }

  window.initializeLessons = function() {
    if (!$('.o-page--cg').length) return;
    initToggler('expand');
    initToggler('materials');
  }
});
