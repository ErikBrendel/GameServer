app = require './app'
http = require 'http'
WebSocket = require 'ws'
url = require 'url'
webpack = require './webpack'

server = http.createServer app.app
wss = new WebSocket.Server {server}


setupGameConnection = (ws) ->
  ws.on 'message', (message) ->
    msg = JSON.parse message
    if msg.request is 'join'
      ws.send app.matchMaker.joinGame msg.gameId, msg.playerName, ws
    else
      ws.foo message

setupServerlistConnection = (ws) ->
  app.matchMaker.addListSocket ws
  console.log 'New Serverlist - client'
  sendError = (msg) -> ws.send JSON.stringify type: 'error', msg: msg
  ws.on 'message', (message) ->
    msg = JSON.parse message
    switch msg.type
      when 'deleteGame'
        gameToDelete = parseInt msg.gameId
        if isNaN(gameToDelete) or not app.matchMaker.deleteGame gameToDelete
          sendError "Error deleting game '#{gameToDelete}'"
      when 'createGame' then app.matchMaker.createGame msg.description
      else sendError "Unknown command: #{msg.type}"


wss.on 'connection', (ws, req) ->
  location = url.parse(req.url, true).path.substr 1
  switch location
    when 'serverlist' then setupServerlistConnection ws
    when '' then setupGameConnection ws
    else
      console.log "Received unknown ws request: #{location}"
      ws.send "BAD REQUEST: No API endpoint named #{location}"

server.listen app.port
server.on 'error', (err) ->
  console.error err.code
server.on 'listening', () ->
  console.info 'listening'
