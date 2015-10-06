(function() {
  function initializeResource() {
    if ($('.lesson-page').length) {
      Unbounded.initializePreviews();
    }
  }

  window.initializeResource = initializeResource;
})();
