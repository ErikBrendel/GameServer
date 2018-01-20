# This class manages the data structures of
# The ViewModel, that the View can access directly

constants = require 'viewModel/Constants'

class ViewModelStorage
  constructor: (ownPlayerId) ->
    @data = {} #TODO initial empty data
    @data.self = @nullObjectPlayer()
    @data.self.id = ownPlayerId
    @data.opponents = []
    @data.opponents[1-@data.self.id] = @nullObjectPlayer() #TODO: This is bad and needs to be fixed some time

  nullObjectPlayer: ->
    return {} #TODO

  getData: -> @data

  update: (dataId, newData) ->
    if constants.SimpleDataIds.includes dataId
      @data[dataId] = newData
      return

    if playeredDataId = constants.PlayeredDataIds.filter((idStart) -> dataId.startsWith idStart)[0]
      playerId = parseInt(dataId.substr playeredDataId.length)
      if playerId is @data.self.id
        @data.self[playeredDataId] = newData
      else
        @getOpponent(playerId)[playeredDataId] = newData
      return

    #TODO: performance here
    if dataId.startsWith 'card'
      cardId = parseInt(dataId.substr 'card'.length)
      @tryToUpdateCardInPlayer @data.self, cardId, newData
      @tryToUpdateCardInPlayer opponent, cardId, newData for opponent in @data.opponents
      for list in [] #TODO game global card list objects
        @tryToUpdateCardInList list, cardId, newData

  getOpponent: (playerId) ->
    if not @data.opponents[playerId]?
      @data.opponents[playerId] = {}
    return @data.opponents[playerId]

  tryToUpdateCardInPlayer: (player, cardId, newData) ->
    return if not player?
    for list in [] #TODO playered card list objects
      @tryToUpdateCardInList list, cardId, newData

  tryToUpdateCardInList: (list, cardId, newData) ->
    cardIndex = 0
    for card in list
      if card.uniqueId is cardId
        list[cardIndex] = newData
      cardIndex++



module.exports = ViewModelStorage
