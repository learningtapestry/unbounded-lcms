$(function () {
  function initSidebar() {
    let observers = [
      new SidebarCGMenu(),
      new SidebarMobile(),
      new TopScroll(),
    ];
    let sidebar = new SideBar(observers);
  }

  function initTasksToggler() {
    $('.c-cg-task__toggler').click(function() {
      $('.c-cg-task__hidden', $(this).parent()).toggle();
      $('.c-cg-task__toggler__hide', $(this)).toggle();
      $('.c-cg-task__toggler__show', $(this)).toggle();
    });
  }

  window.initializeContentGuide = function() {
    if (!$('.o-page--cg').length) return;
    initTasksToggler();
    initSidebar();
  }
})
