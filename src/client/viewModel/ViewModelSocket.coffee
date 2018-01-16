# This serves as the communicator to the server viewModelSocket (redirecting method calls via WebSocket)

class ViewModelSocket
  constructor: (@server, @gameId, username, @setupCallback) ->
    @ws = new WebSocket "ws://#{@server}"
    @ws.onmessage = (msg) => @onMessage msg
    @ws.onopen = =>
      @ws.send JSON.stringify
        request: 'join'
        playerName: username
        gameId: @gameId
    @clients = []

  onMessage: (msg) ->
    data = JSON.parse msg.data
    console.log data
    switch data.type
      when 'update' then @update data.dataId, data.data
      when 'joinSuccess' then @setupCallback data.playerId, @
      else console.log 'Unknown server message:', msg

  update: (dataId, data) ->
    for client in @clients
      client.update dataId, data

  readyToPlay: ->
    @ws.send JSON.stringify
      type: 'readyToPlay'

  # part of the official interface
  init: (newClient) ->
    @clients.push newClient unless @clients.includes newClient

  # part of the official interface
  onEvent: (event) ->
    @ws.send JSON.stringify
      type: 'event'
      event: event

module.exports = ViewModelSocket
