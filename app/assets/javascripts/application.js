// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.

//= require jquery
//= require jquery_ujs
//= require popper
//= require bootstrap
//= require summernote/summernote-bs4.min
//= require activestorage
//= require turbolinks
//= require dataTables/jquery.dataTables
//= require dataTables/extras/dataTables.responsive
//= require_tree .


$(document).ready(function(){

    $('.tab-link').click(function(){
        var tab_id = $(this).attr('data');

        $('.tab-link').removeClass('active');
        $('.tab_inside').removeClass('active');

        $(this).addClass('active');
        $("#"+tab_id).addClass('active');
    });

    $('.hide-filters').on('click', function () {
        $("#filters-to-hide").toggleClass("zero-height");
    });

});
