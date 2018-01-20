res = require './client/resources'

SmoothValue = require 'util/SmoothValue'

window.onload = ->
  document.body.innerHTML = "<b>Res file says: #{res.greeting}</b>
      <div id='block' style='position: absolute; top: 100px; width: 50px; height: 50px; background-color: cyan;'></div> "

  block = document.getElementById 'block'

  blockMove = new SmoothValue 800, 50, 2

  blockMove.addUpdateHandler (value) ->
    block.style.left = "#{value}px"

  random = ->
    min = 50
    width = document.body.offsetWidth - 150
    blockMove.set min + Math.random() * width
    setTimeout random, 600 + Math.random() * 500

  random()
