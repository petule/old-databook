load_function = ->
  customer_table()


$(document).on('turbolinks:load', ->
  load_function()
)