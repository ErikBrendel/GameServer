
MatchMaker = require './MatchMaker'

matchMaker = new MatchMaker


apis = {}

apis.serverlist = (ws) ->
  matchMaker.addListSocket ws
  console.log 'New Serverlist - client'
  sendError = (msg) -> ws.send JSON.stringify type: 'error', msg: msg
  ws.on 'message', (message) ->
    msg = JSON.parse message
    switch msg.type
      when 'deleteGame'
        gameToDelete = parseInt msg.gameId
        if isNaN(gameToDelete) or not matchMaker.deleteGame gameToDelete
          sendError "Error deleting game '#{gameToDelete}'"
      when 'createGame' then matchMaker.createGame msg.description
      else sendError "Unknown command: #{msg.type}"

apis.join = (ws) ->
  ws.on 'message', (message) ->
    msg = JSON.parse message
    if msg.request is 'join'
      ws.send matchMaker.joinGame msg.gameId, msg.playerName, ws
    else
      ws.foo message

module.exports = apis
