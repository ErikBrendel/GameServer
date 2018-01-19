# All the WebSocket endpoints of the server

optionList = require '../shared/util/OptionList'


module.exports = (matchMaker) ->

  apis = {}

  apis.serverlist = (ws) ->
    matchMaker.addListSocket ws
    console.log 'New Serverlist - client'
    sendError = (msg) -> ws.send JSON.stringify type: 'error', msg: msg

    messageHandler = optionList
      deleteGame: (msg) ->
        gameToDelete = parseInt msg.gameId
        if isNaN(gameToDelete) or not matchMaker.deleteGame gameToDelete
          sendError "Error deleting game '#{gameToDelete}'"
      createGame: (msg) -> matchMaker.createGame msg.gameType, msg.description
      listGameTypes: -> ws.send JSON.stringify type: 'listGameTypes', types: ['test/void']
    , (msg) -> sendError "Unknown command: #{msg.type}"

    ws.on 'message', (message) ->
      msg = JSON.parse message
      messageHandler[msg.type](msg)

  apis.join = (ws) ->
    ws.on 'message', (message) ->
      msg = JSON.parse message
      if msg.request is 'join'
        ws.send matchMaker.joinGame msg.gameId, msg.playerName, ws
      else
        ws.foo message

  return apis
