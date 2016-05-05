urlHistory = (function() {

  let state = {};

  let update = function(newState, skipKey) {
    let query = [];
    let mergedState = _.extend(state, newState);

    state = {};
    _.forEach(mergedState, (val, k) => {
      if (skipKey && skipKey(k, val)) { return; }

      if (val) {
        let urlVal = (_.isArray(val) && val.length) ? val.join(',') : val;
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

  return { state: state, update: update, querystringToJSON: querystringToJSON };
})();
