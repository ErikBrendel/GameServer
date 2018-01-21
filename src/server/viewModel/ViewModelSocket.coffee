# This is the door for the ViewModel to access all the Model-Information
# it is allowed to access.
# Presenter and eventHandler should already be connected to everything
# An eventHandler should implement onEvent(event)
# The presenter should have getInitialDataIds() and getPresentation(dataId)


class ViewModelSocket
  constructor: (@game, @presenter, @eventHandler) ->
    @clients = []
    @game.attachObserver @, 'gameStart', 'started'

  update: (notification, aspect, data) ->
    if notification is 'gameStart'
      return @launchGame()

    @sendUpdateToClients notification

  # part of the official interface
  init: (newClient) ->
    console.log 'Player joined'
    @clients.push newClient if not @clients.includes newClient
    return

  playerReady: (playerId) ->
    @game.playerReady playerId

  launchGame: ->
    console.log 'Launching a game...'
    @connectToEverything()
    @sendUpdateToClients id for id in @presenter.getInitialDataIds()

  sendUpdateToClients: (dataId) ->
    newData = @getPresentation dataId
    for client in @clients
      client.update dataId, newData
    return

  getPresentation: (dataId) ->
    @presenter.getPresentation dataId

  # part of the official interface
  onEvent: (event) ->
    @eventHandler.onEvent(event)

module.exports = ViewModelSocket
