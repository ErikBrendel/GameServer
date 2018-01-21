# This class makes matches: (with lots of sulfur) It creates Games,
# does client setup and instantiates all the models

WebSocket = require 'ws'

Game = require './Game'
GameRegistry = require './GameRegistry'

class MatchMaker
  constructor: ->
    @games = []
    @gameCounter = 0
    @listSockets = [] # all webSockets that get notified on list change

  createGame: (type, description) ->
    gameType = GameRegistry.findGameType type
    @games[++@gameCounter] = new Game type, gameType, description
    @updateServerlists()

  deleteGame: (gameId) ->
    return false unless @games[gameId]?
    @games[gameId] = undefined
    @updateServerlists()
    return true

  joinGame: (gameId, name, ws) ->
    return false unless @games[gameId]?
    playerId = @games[gameId].join name, ws
    @updateServerlists()
    return JSON.stringify
      type: 'joinSuccess'
      playerId: playerId

  addListSocket: (ws) ->
    @listSockets.push ws
    @sendServerlistTo ws

  updateServerlists: ->
    @listSockets = @listSockets.filter (ws) -> ws.readyState is WebSocket.OPEN
    setTimeout (=>
      for ws in @listSockets
        @sendServerlistTo ws
    ), 0

  sendServerlistTo: (ws) ->
    gameList = []
    for id, game of @games
      if game?
        gameList.push
          id: id
          players: game.players.length
          description: game.description
    ws.send JSON.stringify
      type: 'updateList'
      list: gameList


module.exports = MatchMaker
