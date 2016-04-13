(function($) {
  /**
   * Initialize plugins on any elements within `elem` (and `elem` itself) that aren't already initialized.
   * without warning
   */
  function initPlugins(elem) {
    const plugins = Object.keys(Foundation._plugins);
    let $elemsToInit = null;
    $.each(plugins, (i, name) => {
      // Localize the search to all elements inside elem, as well as elem itself, unless elem === document
      const selector = `[data-${name}]`;
      let $elem = $(elem).find(selector).addBack(selector);
      // For each plugin found check if it was initialized
      $elem.each((j, el) => {
        const $el = $(el);
        if (!$el.data('zfPlugin')) {
          $elemsToInit = $elemsToInit? $elemsToInit.add($el): $el;
        }
      });
    });
    if ($elemsToInit) {
      $elemsToInit.foundation();
    }
  }

  $.fn.initFoundation = function() {
    initPlugins(this);
    Foundation.IHearYou();
    return this;
  };

})(jQuery);
