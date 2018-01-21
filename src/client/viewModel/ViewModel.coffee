# Each View holds a ViewModel, and displays it's state directly.
# The ViewModel keeps itself up-to-date with the game automatically.

CallbackObserver = require 'util/CallbackObserver'
Observable = require 'util/Observable'
ViewModelStorage = require 'viewModel/ViewModelStorage'

class ViewModel extends Observable
  constructor: (@socket) ->
    super()
    @storage = new ViewModelStorage
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
    @notifyObservers dataId

module.exports = ViewModel
