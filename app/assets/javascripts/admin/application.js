//= require jquery
//= require jquery_ujs
//= require foundation
//= require microplugin
//= require sifter
//= require selectize
//= require turbolinks

$(function() {
  $(document).foundation();

  $('.selectize').selectize({
    allowEmptyOption: true,
    plugins: ['remove_button']
  });  
});
