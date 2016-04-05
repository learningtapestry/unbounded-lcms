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
  $(document).not('.o-cur-card__menu').foundation();
  $(document).smoothscrolling();
  window.initializeContentGuide();
}

$(document).on('ready', ready);
$(document).on('page:load', ready);
