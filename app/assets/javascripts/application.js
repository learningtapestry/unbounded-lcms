//= require turbolinks
//= require ./routes
//= require jquery
//= require jquery_ujs
//= require foundation
//= require react
//= require react_ujs
//= require components

function ready() {
  $(document).foundation();  
}

$(document).on('ready', ready);
$(document).on('page:load', ready);
