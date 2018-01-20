res = require './client/resources'

window.onload = ->
  document.body.innerHTML = "<b>Res file says: #{res.greeting}</b>"