
MatchMaker = require './MatchMaker'
optionList = require '../shared/util/OptionList'

matchMaker = new MatchMaker


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
    createGame: (msg) -> matchMaker.createGame msg.description
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

module.exports = apis
