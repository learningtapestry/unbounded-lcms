$(function () {
  const COMPONENT_PREFIX = '.c-lesson';

  function initExpandToggler() {
    let prefix = `${COMPONENT_PREFIX}-expand`;
    $(`${prefix}__toggler`).click(function() {
      $(`${prefix}__hidden`, $(this).parent()).toggle();
      $(`${prefix}__toggler__hide`, $(this)).toggle();
      $(`${prefix}__toggler__show`, $(this)).toggle()
    })
  }

  initExpandToggler()
});
