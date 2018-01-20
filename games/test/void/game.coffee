class VoidPresenter
  constructor: (@game, @player) ->

  getInitialDataIds: -> ['fooString', 'barString']

  getPresentation: (dataId) -> "Data_#{dataId}"


class VoidEventHandler
  constructor: (@game, @player) ->

  onEvent: (event) ->
    console.log "Received event #{JSON.stringify event}"


class VoidPlayer
  constructor: (@name) ->


class VoidGame
  constructor: ->

  addPlayer: (name) ->
    player = new VoidPlayer name
    return
      presenter: new VoidPresenter @, player
      eventHandler: new VoidEventHandler @, player

module.exports =
  name: "Void Game"
  description: "It does nothing"
  newInstance: -> new VoidGame()
