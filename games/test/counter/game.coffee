
CounterGame = require './game/CounterGame'

module.exports =
  name: "Counter Game"
  description: "Who can click faster?"
  newInstance: -> new CounterGame()
