//= require turbolinks
//= require ./routes
//= require jquery
//= require jquery_ujs
//= require jquery/smoothscrolling
//= require foundation
//= require jquery/foundation.magellanex
//= require react
//= require react_ujs
//= require components
//= require content_guides

function ready() {
  $(document).foundation();
  $(document).smoothscrolling();
  window.initializeContentGuide();
}

function readyTurbolinks() {
  ready();
  // initialize foundation event listeners (they are initializing on window.load)
  Foundation.IHearYou();
}

$(document).on('ready', ready);
$(document).on('page:load', readyTurbolinks);
