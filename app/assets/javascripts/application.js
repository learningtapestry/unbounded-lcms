//= require turbolinks
//= require jquery
//= require jquery_ujs
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
//= require components
//= require initializers/content_guides
//= require initializers/about_people
//= require initializers/social_sharing
//= require initializers/google_analytics
//= require initializers/leadership
//= require initializers/header_dropdown
//= require initializers/lessons
//= require initializers/loadasync
//= require initializers/soundcloud
//= require initializers/subscribe_placeholder
//= require initializers/pdf_preview
//= require initializers/resource_details
//= require initializers/lessons

ready(function() {
  $(document).initFoundation();
  $('.o-page--resource').smoothscrolling();
  window.initializeHeaderDropdown();
  window.initializeContentGuide();
  window.initializeAboutPeople();
  window.initializeSocialSharing();
  window.initializeLeadership();
  window.initializeLessons();
  //window.initializeFreshdesk();
  window.initializeGoogleAnalytics();
  window.initializeSoundCloud();
  window.initializeSubscribePlaceholder();
  window.initializePDFPreview();
  window.initializeResourceDetails();
  window.initializeTabs();
  window.initializeLessons();
});

$(document).on('page:before-unload', function(nodes) {
  urlHistory.emptyState();
});
