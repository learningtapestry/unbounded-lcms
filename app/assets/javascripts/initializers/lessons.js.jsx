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
    new SideBar(observers, { clsPrefix: 'ld', breakPoint: 'large', bHandleMobile: false });
  }

  function initToggler(component) {
    let prefix = `${COMPONENT_PREFIX}-${component}`;
    $(`${prefix}__toggler`).click(function() {
      $(`${prefix}__content--hidden`, $(this).parent()).toggle();
      $(`${prefix}__toggler--hide`, $(this)).toggle();
      $(`${prefix}__toggler--show`, $(this)).toggle();
    })
  }

  const initSelects = () => {
    const menu = document.getElementById('ld-sidebar-menu')
    if (!menu) return;

    // TODO remove when heap analytics will be available
    top.heap || (top.heap = { track: function(a, b) { console.debug('heap track: ', a, b) } });

    const eachNode = (selector, fn) => [].forEach.call(document.querySelectorAll(selector), fn);

    let lastParentIdx = null
    const items = [].map.call(menu.querySelectorAll('[href][data-duration][data-level]'), (x, i) => {
      let level = parseInt(x.dataset.level);
      if (level === 1) lastParentIdx = i;
      return {
        active: true, // by default
        duration: parseInt(x.dataset.duration),
        id: x.getAttribute('href').substr(1),
        parent: level > 1 ? lastParentIdx : null
      }
    });

    const updateMenu = parentId => {
      let parent = items[parentId];
      let children = items.filter(x => x.parent === parentId);
      let parentEnabled = children.some(x => x.active);
      let parentDuration = children.filter(x => x.active).reduce((a, x) => a + x.duration, 0);
      let totalTime = items.filter(x => x.parent !== null && x.active).reduce((a, x) => a + x.duration, 0);

      eachNode(`[href="#${parent.id}"]`, parentNode => {
        parentNode.classList.toggle('o-ld-sidebar-item__content--disabled', !parentEnabled);
        parentNode
          .querySelector('.o-ld-sidebar-item__time')
          .textContent = parentDuration > 0 ? `${parentDuration} min` : '';
      })

      eachNode('.o-ld-sidebar-item__time--summary', x => { x.textContent = `${totalTime} min` });
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
              resolve()
            } else {
              setTimeout(poll, 2000)
            }
          }).fail(x => {
            console.warn('check pdf export status', x)
            reject(x);
          })
        }
        setTimeout(poll, 2000)
      })
    }

    eachNode('a[data-pdftype]', link => {
      link.addEventListener('click', e => {
        let excludes = items.filter(x => x.parent !== null && x.active == false).map(x => x.tag)
        if (excludes.length === 0) return;

        let excludesString = excludes.join(',')
        if (link.dataset.excludes === excludesString) return

        e.preventDefault();

        link.classList.add('o-ub-btn--disabled');
        link.dataset.excludes = excludesString;

        $.post(`${location.pathname}/export/pdf`, {
          excludes: excludes,
          type: link.dataset.pdftype
        }).done(response => {
          link.href = response.url
          if (response.id) {
            pollPdfStatus(response.id, link).then(() => {
              link.classList.remove('o-ub-btn--disabled')
              link.click();
            });
          } else {
            link.classList.remove('o-ub-btn--disabled');
            link.click();
          }
        }).fail(x => {
          console.warn('export pdf', x);
          link.classList.remove('o-ub-btn--disabled');
        })
      })
    });

    const toggleHandler = (element, item) => {
      element.classList.toggle('deselected');
      item.active = !element.classList.contains('deselected');
      eachNode(`[href="#${item.id}"]`, x => {
        x.classList.toggle('o-ld-sidebar-item__content--disabled', !item.active)
      });
      updateMenu(item.parent)
    }

    items
      .filter(x => x.parent !== null)
      .forEach(item => {
        let content = document.querySelector(`[data-id="${item.id}"]`);
        if (!content) return;

        item.tag = content.dataset.tag

        let container = document.createElement('div');
        content.appendChild(container);

        let component = React.createElement(SelectActivityToggle, {
          callback: toggleHandler.bind(null, content, item),
          item,
          meta: content.querySelector('.o-ld-activity__metacognition')
        });
        ReactDOM.render(component, container);
      })
  }

  window.initializeLessons = function() {
    if (!$('.o-page--ld').length) return;
    initPdToggler();
    initSelects()
    initSidebar();
    initToggler('expand');
    initToggler('materials');
  }
});
