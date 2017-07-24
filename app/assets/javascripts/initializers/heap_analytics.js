(function() {
  var catchHovers = function() {
    var hovered = {}, node, text;
    return function(e) {
      node = document.querySelector('[data-toggle="' + e.target.id + '"]')
      if (node && (text = node.innerText) && hovered[text] === undefined) {
        hovered[text] = true;
        heap.track('Keyword Hover', { target: text })
      }
    }
  }

  var catchScroll = function() {
    var active = null, scrollPoints = {}, text;
    return function() {
      active = document.querySelectorAll('.o-ld-sidebar__item--active')
      if (active.length === 0) return;
      text = active[active.length - 1].textContent.replace(/\s+/g, ' ').trim();
      if (scrollPoints[text] === undefined) {
        scrollPoints[text] = true;
        heap.track('Scroll Page', { target: text });
      }
    }
  }

  var catchSelection = function() {
    var x;
    return _.debounce(function() {
      x = document.getSelection().toString();
      if (x && x.length) {
        heap.track('Select Text', { size: x.length, text: x.substring(0, 100) });
      }
    }, 500, { leading: false });
  }

  var initScrollCatching = function() {
    $(document.querySelector('[id$="-page"]')).on('scrollme.zf.trigger', catchScroll())
  }

  document.addEventListener('DOMContentLoaded', function() {
    if (top.heap && typeof heap.track === 'function') {
      document.addEventListener('page:before-change', function() {
        heap.track('Page Before Change')
      });

      document.addEventListener('page:load', initScrollCatching);
      initScrollCatching();

      document.addEventListener('selectionchange', catchSelection());

      $(document).on('show.zf.dropdown', catchHovers());

      window.addEventListener('beforeunload', function() {
        heap.track('Page Unload')
      });
    }
  })
})()
