class CounterEventHandler
  constructor: (@game, @player) ->

  onEvent: (event) ->
    if event.type is 'count'
      @player.count()
    console.error "Received unknown event #{JSON.stringify event}!"