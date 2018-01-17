# The EventHandler receives events from a client and updates the model respectively

class EventHandler
  constructor: (@game, @player) ->

  onEvent: (event) ->
    #TODO

module.exports = EventHandler