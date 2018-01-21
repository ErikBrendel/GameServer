# A generic running Game Object, that holds the concrete instance

ViewModel_Remote = require './viewModel/ViewModel_Remote'
ViewModelSocket = require './viewModel/ViewModelSocket'

Observable = require '../shared/util/Observable'

class Game extends Observable
  constructor: (@gameTypeName, @gameType, @description) ->
    super()
    @players = []
    @game = @gameType.newInstance()

  join: (playerName, ws) ->
    return undefined if @players.length >= @gameType.maxPlayers
    playerId = @players.length

    {presenter, eventHandler} = @game.addPlayer playerName

    socket = new ViewModelSocket @, presenter, eventHandler
    viewModel = new ViewModel_Remote socket, playerId, ws
    @players.push
      name: playerName
      ready: false
      ws: ws
      vms: socket
      vm: viewModel
    @game.addPlayer playerName
    return playerId

  playerReady: (playerId) ->
    player = @players[playerId]
    return if player.ready
    player.ready = true
    @game.playerReady player

    readyPlayerCount = @players
      .filter (p) -> p.ready
      .length
    if readyPlayerCount is @players.length and readyPlayerCount >= @gameType.minPlayers
      @game.start()

module.exports = Game
