// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require lodash
//= require jquery
//= require jquery_ujs
//= require bootstrap-sprockets
//= require ckeditor/init
//= require jquery_nested_form
//= require turbolinks
//= require js-routes
//= require knockout
//= require i18n
//= require i18n/translations
//= require_tree ./plugins
//= require_tree .

function t(args) {
  return I18n.t(args);
}

var ready = function() {
  $('.selectize').selectize({ allowEmptyOption: true });
  window.initializeLobjectForm();
  window.initializeLobjectList();
  window.initializeTree();
  window.initializeCurriculum();
};

$(document).ready(ready);
$(document).on('page:load', ready);
