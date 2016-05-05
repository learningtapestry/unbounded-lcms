urlHistory = (function() {

  var state = {
    turbolinks: true,
    url: '',
  };

  let update = function(newState, skipCondition) {
    let query = [];
    _.forEach(newState, (val, k) => {
      if (skipCondition && skipCondition(k, val)) { return; }

      if (val) {
        let urlVal = (_.isArray(val) && val.length) ? val.join(',') : val;
        if (urlVal.length) query.push( k + '=' + urlVal);
      }
    });
    query = query.join('&');
    query = query ? '?' + query : window.location.pathname;

    // Make pushState play nice with Turbolinks.
    // Ref https://github.com/turbolinks/turbolinks-classic/issues/363
    state = _.merge(state, { turbolinks: true, url: query });
    window.history.pushState(state, null, query);
  };

  return {
    state: state,
    update: update,
  };

})();
