# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
user_table = ->
  console.log('test')
  language_code = 'cs'
  $('#library-tbl').DataTable("language": {url: '/plugins/tables_'+language_code+'.json'},"iDisplayLength": 5, "lengthMenu": [[5, 10, 25, 50, -1], [5, 10, 25, 50, "All"]] )

window.user_table = user_table
