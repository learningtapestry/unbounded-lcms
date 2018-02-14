//= require turbolinks
//= require jquery
//= require jquery_ujs
//= require i18n/translations
//= require vendor/modernizr-custom
//= require vendor/swiper.jquery
//= require vendor/pdfobject.js
//= require ready
//= require jquery/smoothscrolling
//= require foundation
//= require jquery/foundation.magellanex
//= require jquery/foundation.initialize
//= require jquery/tabs
//= require react
//= require react_ujs
//= require js-routes
//= require initializers/heap_analytics
//= require components
//= require initializers/lessons
//= require initializers/loadasync
//= require initializers/pdf_preview
//= require initializers/soundcloud
//= require_tree ./initializers/sidebar

// eslint-disable-next-line no-undef
ready(function() {
  $(document).initFoundation();
  $('.o-page--resource').smoothscrolling();
  window.initializeSoundCloud();
  window.initializePDFPreview();
  window.initializeTabs();
  window.initializeLessons();
});

$(document).on('page:before-unload', function() {
  urlHistory.emptyState();
});
