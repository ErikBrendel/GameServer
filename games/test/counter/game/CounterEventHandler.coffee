class CounterEventHandler
  constructor: (@game, @player) ->

  onEvent: (event) ->
    return unless @game.running
    if event.type is 'count'
      @player.count()
      return
    console.error "Received unknown event #{JSON.stringify event}!"

module.exports = CounterEventHandler
