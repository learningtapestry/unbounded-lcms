//= require jquery
//= require jquery_ujs
//= require ckeditor/init
//= require foundation
//= require microplugin
//= require sifter
//= require selectize
//= require turbolinks
//= require react
//= require react_ujs
//= require ../routes
//= require ../components
//= require ./components

$(function() {
  $(document).foundation();

  $('.selectize').selectize({
    allowEmptyOption: true,
    plugins: ['remove_button']
  });  
});
