# A generic running Game Object, that holds the concrete instance

ViewModel_Remote = require './viewModel/ViewModel_Remote'
ViewModelSocket = require './viewModel/ViewModelSocket'

class Game
  constructor: (@gameTypeName, @gameType, @description) ->
    @players = []
    @game = @gameType.newInstance()

  join: (playerName, ws) ->
    playerId = @players.length

    {presenter, eventHandler} = @game.addPlayer playerName

    socket = new ViewModelSocket @, player, presenter, eventHandler
    viewModel = new ViewModel_Remote socket, playerId, ws
    @players.push
      player: player
      ws: ws
      vms: socket
      vm: viewModel
    @game.addPlayer playerName

module.exports = Game
