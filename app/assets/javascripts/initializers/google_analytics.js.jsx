window.initializeGoogleAnalytics = () => {
  if (window.ga) {
    ga('set',  'location', location.href.split('#')[0]);
    ga('send', 'pageview', { "title": document.title });
  }
}

$(function () {

  function reportLastSearch() {
    var maxInputDelayMsec = 7000;
    var checkEveryMsec = 1000;
    var now = new Date().getTime();
    var last = ($.cookie('_lastsearch_time') || now);
    if ((now - last) > maxInputDelayMsec) {
      $.post( "/log_search", {
        search_url: $.cookie('_lastsearch'),
        referrer: $.cookie('_lastsearch_referrer'),
      }).done(function( data ) {
          console.log( "response: " + data );
          $.removeCookie('_lastsearch');
          $.removeCookie('_lastsearch_time');
          $.removeCookie('_lastsearch_referrer');
      });
    };
    setTimeout(reportLastSearch, checkEveryMsec);
  }

  reportLastSearch();
});
