ViewModel = require 'viewModel/ViewModel'
ViewModelSocket = require 'viewModel/ViewModelSocket_Remote'
findGetParam = require 'view/findGetParam'


DomView = require './view/DomView'


# local mvvm setup
new ViewModelSocket findGetParam('url'), findGetParam('gameId'), findGetParam('username'), (playerId, socket) ->
  viewModel = new ViewModel socket, playerId
  window.vm = viewModel
  new DomView viewModel
  socket.readyToPlay()
