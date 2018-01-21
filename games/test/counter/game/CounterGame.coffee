
CounterPlayer = require './CounterPlayer'
CounterPresenter = require './CounterPresenter'
CounterEventHandler = require './CounterEventHandler'

class CounterGame
  constructor: ->
    @counterValue = 0
    @playersJoined = 0
    @running = false

  addPlayer: (name) ->
    sign = if @playersJoined is 0 then 1 else -1
    @playersJoined++
    player = new CounterPlayer @, name, sign
    return
      presenter: new CounterPresenter @, player
      eventHandler: new CounterEventHandler @, player

  playerReady: (name) ->

  start: ->
    @running = true

module.exports = CounterGame
