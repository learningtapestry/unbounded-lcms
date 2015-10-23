(function() {
  function initializeResource() {
    if ($('.lesson-page').length) {
      Unbounded.initializePreviews();

      $('.resource-attachment').on('click', function() {
        ga('send', 'event', {
          eventCategory: 'download',
          eventAction: 'resource_attachment',
          eventLabel: $(this).attr('href')
        });
      });
    }
  }

  window.initializeResource = initializeResource;
})();
