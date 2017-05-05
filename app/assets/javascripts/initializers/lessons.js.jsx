$(function () {
  const COMPONENT_PREFIX = '.c-lesson';

  function initToggler(component) {
    let prefix = `${COMPONENT_PREFIX}-${component}`;
    $(`${prefix}__toggler`).click(function() {
      $(`${prefix}__hidden`, $(this).parent()).toggle();
      $(`${prefix}__toggler__hide`, $(this)).toggle();
      $(`${prefix}__toggler__show`, $(this)).toggle()
    })
  }

  window.initializeLessons = function() {
    if (!$('.o-page--cg').length) return;
    initToggler('expand');
    initToggler('materials');
  }
});
