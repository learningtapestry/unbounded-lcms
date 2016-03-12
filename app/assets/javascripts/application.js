//= require turbolinks
//= require ./routes
//= require jquery
//= require jquery_ujs
//= require foundation
//= require react
//= require react_ujs
//= require components
//= require content_guides

function ready() {
  $(document).foundation();
  window.initializeContentGuide();
}

$(document).on('ready', ready);
$(document).on('page:load', ready);
