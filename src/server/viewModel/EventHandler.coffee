# The EventHandler receives events from a client and updates the model respectively

Card = require '../magic/Card'

class EventHandler
  constructor: (@game, @player) ->

  onEvent: (event) ->
    #TODO

module.exports = EventHandler