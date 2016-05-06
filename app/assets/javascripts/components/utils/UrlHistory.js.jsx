urlHistory = (function() {

  let state = {};

  let update = function(newState, skipKey) {
    let query = [];
    let mergedState = _.extend(state, newState);

    state = {};
    _.forEach(mergedState, (val, k) => {
      if (skipKey && skipKey(k, val)) { return; }

      if (val) {
        let urlVal = (_.isArray(val) && val.length) ? val.join(',') : val.toString();
        if (urlVal.length) {
          query.push( k + '=' + urlVal);
          state[k] = val;
        }
      }
    });
    query = query.join('&');
    let path = query ? '?' + query : window.location.pathname;

    window.history.pushState(params(path), null, path);
  };

  let params = function(url) {
    // Make pushState play nice with Turbolinks.
    // Ref https://github.com/turbolinks/turbolinks-classic/issues/363
    return { turbolinks: true, url: url };
  };

  let querystringToJSON = function () {
    var pairs = location.search.slice(1).split('&');

    var result = {};
    pairs.forEach(function(pair) {
      pair = pair.split('=');
      var val = decodeURIComponent(pair[1] || '');
      if (val.indexOf(',') > -1 ) val = val.split(',');
      result[pair[0]] = val;
    });

    return JSON.parse(JSON.stringify(result));
  };

  const updatePaginationParams = function(newState) {
    var params = {};

    params.page = (newState.current_page == 1) ? null : newState.current_page;
    params.per_page = (newState.per_page == 20) ? null : newState.per_page;
    params.tab = newState.activeTab;

    update(params);
  }

  return {
    state: state,
    update: update,
    updatePaginationParams: updatePaginationParams,
    querystringToJSON: querystringToJSON
  };
})();
