$(function () {
  const COMPONENT_PREFIX = '.o-ld';

  function initPdToggler() {
    let prefix = `${COMPONENT_PREFIX}-pd`;
    $(`${prefix}-toggler`).click(function() {
      $(`${prefix}-caption`, $(this).parent()).toggle();

      console.log($(this).closest(prefix));

      $(this)
        .closest(prefix)
        .toggleClass(`o-ld-pd--collapsed o-ld-pd--expanded`);

      $(this)
        .find('i')
        .toggleClass('fa-expand fa-compress');
    });
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
    if (!$('.o-page--cg').length) return;
    initPdToggler();
    initToggler('expand');
    initToggler('materials');
  }
});
