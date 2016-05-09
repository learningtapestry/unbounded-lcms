//= require turbolinks
//= require ./routes
//= require jquery
//= require jquery_ujs
//= require ready
//= require jquery/smoothscrolling
//= require foundation
//= require jquery/foundation.magellanex
//= require jquery/foundation.initialize
//= require vendor/freshwidget
//= require react
//= require react_ujs
//= require components
//= require content_guides
//= require about_people
//= require social_sharing

ready(function() {
  $(document).initFoundation();
  $(document).smoothscrolling();
  window.initializeContentGuide();
  window.initializeAboutPeople();
  window.initializeSocialSharing();
});
