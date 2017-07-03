//= require jquery
//= require jquery_ujs
//= require jquery_nested_form
//= require jquery/foundation.initialize
//= require ckeditor/init
//= require foundation
//= require microplugin
//= require sifter
//= require selectize
//= require react
//= require react_ujs
//= require vendor/html.sortable.min
//= require vendor/jquery.tagsinput
//= require jstree
//= require ../ready
//= require ../components
//= require ./components

ready(function() {
  $(document).initFoundation();

  $('.selectize').selectize({
    allowEmptyOption: true,
    plugins: ['remove_button']
  });
});
