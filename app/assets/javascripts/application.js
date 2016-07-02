//= require turbolinks
//= require jquery
//= require jquery_ujs
//= require vendor/modernizr-custom
//= require ready
//= require jquery/smoothscrolling
//= require foundation
//= require jquery/foundation.magellanex
//= require jquery/foundation.initialize
//= require react
//= require react_ujs
//= require components
//= require initializers/content_guides
//= require initializers/about_people
//= require initializers/social_sharing
//= require initializers/google_analytics

ready(function() {
  $(document).initFoundation();
  $(document).smoothscrolling();
  window.initializeContentGuide();
  window.initializeAboutPeople();
  window.initializeSocialSharing();
  //window.initializeFreshdesk();
  window.initializeGoogleAnalytics();
});

$(document).on('page:before-unload', function(nodes) {
  urlHistory.emptyState();
});
