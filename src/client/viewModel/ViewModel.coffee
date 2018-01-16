# Each View holds a ViewModel, and displays it's state directly.
# The ViewModel keeps itself up-to-date with the game automatically.

CallbackObserver = require 'util/CallbackObserver'
Observable = require 'util/Observable'
ViewModelStorage = require 'viewModel/ViewModelStorage'
constants = require 'viewModel/Constants'

class ViewModel extends Observable
  constructor: (@socket, ownPlayerId) ->
    super()
    @storage = new ViewModelStorage ownPlayerId
    @changed()

  changed: ->
    @socket.init @

  getData: ->
    @storage.getData()

  # part of the official interface
  update: (dataId, data) ->
    @storage.update dataId, data
    @notify dataId

  # part of the official interface
  onEvent: (event) ->
     @socket.onEvent event

  onUpdateDo: (updateId, callback) ->
    observer = new CallbackObserver callback
    observer.registerOn @, updateId

  notify: (dataId) ->
    if constants.SimpleDataIds.includes dataId
      @notifyObservers dataId
      return

    if dataId.startsWith 'card'
      cardId = parseInt(dataId.substr 'card'.length)
      @notifyObservers 'card', cardId
      return

    if @playeredDataId = constants.PlayeredDataIds.filter((idStart) -> dataId.startsWith idStart)[0]
      playerId = parseInt(dataId.substr @playeredDataId.length)
      @notifyObservers @playeredDataId, playerId

      if playerId is @getData().self.id
        @notifyObservers "own-#{@playeredDataId}", playerId
      else
        @notifyObservers "opponent-#{@playeredDataId}", playerId
      return

    console.log 'Unknown dataId: ' + dataId


module.exports = ViewModel
