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
//= require jquery
//= require jquery_ujs
//= require bootstrap-sprockets
//= require ckeditor/init
//= require jquery_nested_form
//= require turbolinks
//= require_tree ./plugins
//= require_tree .

var ready = function() {
  $('.selectize').selectize();
  window.initializeLobjectForm();
  window.initializeLobjectList();
  window.initializeTree();

  $('.lesson[data-toggle=popover]').popover ({
  	html: true,
  	trigger: 'manual',
  	template: '<div class="popover popover-lesson" role="tooltip"><div class="arrow"></div><div class="popover-content"></div></div>'
  }).on("mouseenter", function () {
    var _this = this;
    $(this).popover("show");
    $(this).siblings(".popover").on("mouseleave", function () {
      $(_this).popover('hide');
    });
  }).on("mouseleave", function () {
    var _this = this;
    setTimeout(function () {
      if (!$(".popover:hover").length) { $(_this).popover("hide")}
    }, 50);
  });
};

$(document).ready(ready);
$(document).on('page:load', ready);
