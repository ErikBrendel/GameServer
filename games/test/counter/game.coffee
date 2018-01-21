
CounterGame = require './game/CounterGame'

module.exports =
  name: "Counter Game"
  description: "Who can click faster?"
  minPlayers: 2
  maxPlayers: 2
  newInstance: -> new CounterGame()
