# This is the door for the ViewModel to access all the Model-Information
# it is allowed to access.

Presenter = require './Presenter'
EventHandler = require './EventHandler'

class ViewModelSocket
  constructor: (@game, @player) ->
    @presenter = new Presenter @game, @player
    @eventHandler = new EventHandler @game, @player
    @clients = []
    @game.attachObserver @, 'gameStart', 'started'

  connectToEverything: ->
    #TODO

  update: (notification, aspect, data) ->
    if notification is 'gameStart'
      return @launchGame()

    @sendUpdateToClients notification

  # part of the official interface
  init: (newClient) ->
    console.log 'Player joined'
    @clients.push newClient if not @clients.includes newClient
    return

  playerReady: ->
    @player.setReady()

  launchGame: ->
    console.log 'LAUNCHING GAME...'
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