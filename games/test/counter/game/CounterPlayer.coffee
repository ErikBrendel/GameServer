class CounterPlayer
  constructor: (@game, @name, @sign) ->

  count: ->
    @game.changeCounterValue @sign

module.exports = CounterPlayer
