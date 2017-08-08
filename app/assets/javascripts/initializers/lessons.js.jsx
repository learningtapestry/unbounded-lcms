$(function () {
  const COMPONENT_PREFIX = '.o-ld';

  const initPd = () => {
    const prefix = `${COMPONENT_PREFIX}-pd`;
    const togglerSelector = `${prefix}-toggler`;

    $(`${prefix}__minimizer`).click(function() {
      $(this).closest(prefix).find(togglerSelector).click();
    });

    $(togglerSelector).click(function() {
      const el = $(this).closest(prefix);
      el.toggleClass('o-ld-pd--collapsed o-ld-pd--expanded')
        .find('.o-ld-pd__description')
        .toggleClass('o-ld-pd__description--hidden');

      if (PDFObject.supportsPDFs) { embedPdf(el.find('.o-ld-pd-pdf__object')[0]); }
    });

    const embedPdf = (el) => {
      if (!el) return;

      let url = el.dataset.url;
      if (!PDFObject.supportsPDFs) {
        url = `${Routes.pdf_proxy_resources_path()}?url=${url}`;
      }

      const options = {
        pdfOpenParams: { page: 1, view: 'FitV' },
        PDFJS_URL: Routes.pdfjs_full_path()
      };
      PDFObject.embed(url, el, options);
    };

    $('.o-ld-pd-pdf__object').each(function(_, el) { embedPdf(el); });
  };

  function initSidebar() {
    const observers = [
      new top.SidebarDocMenu(),
      new top.TopScroll(),
      new top.SidebarSticky(),
    ];
    new top.SideBar(observers, { clsPrefix: 'ld', breakPoint: 'large', bHandleMobile: false });
  }

  function initToggler(component) {
    let prefix = `${COMPONENT_PREFIX}-${component}`;
    $(`${prefix}__toggler`).click(function() {
      $(`${prefix}__content--hidden`, $(this).parent()).toggle();
      $(`${prefix}__toggler--hide`, $(this)).toggle();
      $(`${prefix}__toggler--show`, $(this)).toggle();
    });
  }

  const initSelects = () => {
    const menu = document.getElementById('ld-sidebar-menu');
    if (!menu) return;

    // TODO remove when heap analytics will be available
    top.heap || (top.heap = { track: function(a, b) { console.log('heap track: ', a, b); } });

    const eachNode = (selector, fn) => [].forEach.call(document.querySelectorAll(selector), fn);

    let lastParentIdx = null;
    const items = [].map.call(menu.querySelectorAll('[href][data-duration][data-level]'), (x, i) => {
      let level = parseInt(x.dataset.level);
      if (level === 1) lastParentIdx = i;
      return {
        active: true, // by default
        duration: parseInt(x.dataset.duration),
        id: x.getAttribute('href').substr(1),
        parent: level > 1 ? lastParentIdx : null
      };
    });

    const durationString = x => `${x} min${x > 1 ? 's' : ''}`;

    const updateMenu = parentId => {
      let parent = items[parentId];
      let children = items.filter(x => x.parent === parentId);
      let parentEnabled = children.some(x => x.active);
      let parentDuration = children.filter(x => x.active).reduce((a, x) => a + x.duration, 0);
      parentDuration = parentDuration > 0 ? durationString(parentDuration) : '';
      let totalTime = items.filter(x => x.parent !== null && x.active).reduce((a, x) => a + x.duration, 0);

      eachNode(`[href="#${parent.id}"]`, parentNode => {
        parentNode.classList.toggle('o-ld-sidebar-item__content--disabled', !parentEnabled);
        parentNode.querySelector('.o-ld-sidebar-item__time').textContent = parentDuration;
      });

      let contentGroup = document.getElementById(parent.id);
      let groupDuration = contentGroup ? contentGroup.querySelector('.o-ld-title__time') : null;
      if (groupDuration) groupDuration.textContent = parentDuration;

      eachNode('.o-ld-sidebar-item__time--summary', x => { x.textContent = durationString(totalTime); });
    };

    const pollPdfStatus = (id, link) => {
      $(link).prepend('<i class="fa fa-spin fa-spinner u-margin-right--base" />');

      return new Promise((resolve, reject) => {
        let poll = () => {
          $.getJSON(`${location.pathname}/export/pdf-status`, {
            jid: id,
            _: Date.now() // prevent cached response
          }).done(x => {
            if (x.ready) {
              $(link).find('.fa').remove();
              resolve();
            } else {
              setTimeout(poll, 2000);
            }
          }).fail(x => {
            console.warn('check pdf export status', x);
            reject(x);
          });
        };
        setTimeout(poll, 2000);
      });
    };

    eachNode('a[data-pdftype]', link => {
      link.addEventListener('click', e => {
        let excludes = items.filter(x => x.parent !== null && x.active === false).map(x => x.tag);
        let excludesString = excludes.join(',');
        if (link.dataset.excludes === excludesString) return;

        e.preventDefault();

        link.classList.add('o-ub-btn--disabled');
        link.dataset.excludes = excludesString;

        let finish = () => {
          link.classList.remove('o-ub-btn--disabled');
          link.click();
        };

        $.post(`${location.pathname}/export/pdf`, {
          excludes: excludes,
          type: link.dataset.pdftype
        }).done(response => {
          link.href = response.url;
          if (response.id) {
            pollPdfStatus(response.id, link).then(finish);
          } else {
            finish();
          }
        }).fail(x => {
          console.warn('export pdf', x);
          finish();
        });
      });
    });

    const toggleHandler = (element, item) => {
      element.classList.toggle('deselected');
      item.active = !element.classList.contains('deselected');
      eachNode(`[href="#${item.id}"]`, x => {
        x.classList.toggle('o-ld-sidebar-item__content--disabled', !item.active);
      });
      updateMenu(item.parent);
      setTimeout(() => {
        let hasDeselected = items.some(x => x.active === false);
        $('.o-ld-sidebar__item.o-ld-sidebar-break').toggle(!hasDeselected);
      });
    };

    items
      .filter(x => x.parent !== null)
      .forEach(item => {
        let content = document.querySelector(`[data-id="${item.id}"]`);
        if (!content) return;

        item.tag = content.dataset.tag;

        let container = document.createElement('div');
        content.appendChild(container);

        let component = React.createElement(top.SelectActivityToggle, {
          callback: toggleHandler.bind(null, content, item),
          item,
          preface: content.querySelector('.o-ld-title .dropdown-pane'),
          meta: content.querySelector('.o-ld-activity__metacognition'),
        });
        ReactDOM.render(component, container);
      });
  };

  window.initializeLessons = function() {
    if (!$('.o-page--ld').length) return;
    initPd();
    initSelects();
    initSidebar();
    initToggler('expand');
    initToggler('materials');
  };
});
