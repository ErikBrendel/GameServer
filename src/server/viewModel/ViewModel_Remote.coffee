# This class may look like a ViewModel to the VMSocket, but in reality, it passes all information
# to the client via a WebSocket - connection.

class ViewModel
  constructor: (@socket, @playerId, @ws) ->
    @ws.foo = (msg) => @onMessage msg
    @socket.init @

  # part of the official interface
  update: (dataId, data) ->
    @ws.send JSON.stringify
      type: 'update'
      dataId: dataId
      data: data

  # when a WebSocket - message is received
  onMessage: (message) ->
    msg = JSON.parse message
    switch msg.type
      when 'event' then @onEvent msg.event
      when 'readyToPlay' then @socket.playerReady @playerId

  onEvent: (event) ->
    @socket.onEvent event

module.exports = ViewModel
