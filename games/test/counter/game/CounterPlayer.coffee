class CounterPlayer
  constructor (@name, @sign) ->

  count: ->
    @game.counterValue += @sign

module.exports = CounterPlayer
