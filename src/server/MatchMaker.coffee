# This class makes matches: (with lots of sulfur) It creates Games,
# does client setup and instantiates all the models

WebSocket = require 'ws'

ViewModel = require './viewModel/ViewModel'
ViewModelSocket = require './viewModel/ViewModelSocket'

Game = {}  #TODO
Player = {} #TODO

class MatchMaker
  constructor: ->
    @games = []
    @gameCounter = 0
    @listSockets = [] # all webSockets that get notified on list change

  createGame: (description) ->
    @games[++@gameCounter] =
      game: new Game #TODO
      players: []
      description: description
    @updateServerlists()

  deleteGame: (gameId) ->
    return false unless @games[gameId]?
    @games[gameId] = undefined
    @updateServerlists()
    return true

  joinGame: (gameId, name, ws) ->
    return false unless @games[gameId]?
    player = new Player name
    socket = new ViewModelSocket @games[gameId].game, player
    viewModel = new ViewModel socket, playerId, ws
    @games[gameId].game.addPlayer player
    @games[gameId].players.push
      player: player
      ws: ws
      vms: socket
      vm: viewModel
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
