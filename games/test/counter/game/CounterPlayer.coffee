class CounterPlayer
  constructor: (@game, @name, @sign) ->

  count: ->
    @game.counterValue += @sign

module.exports = CounterPlayer
