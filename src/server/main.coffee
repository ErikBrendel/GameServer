app = require './app'
http = require 'http'
WebSocket = require 'ws'
url = require 'url'
webpack = require './webpack'

server = http.createServer app.app
wss = new WebSocket.Server {server}

wss.on 'connection', (ws, req) ->
  location = url.parse(req.url, true).path.substr 1

  api = app.apis[location]
  if api?
    api ws
  else
    console.log "Received unknown ws request: #{location}"
    ws.send "BAD REQUEST: No API endpoint named #{location}"

server.listen app.port
server.on 'error', (err) ->
  console.error err.code
server.on 'listening', () ->
  console.info 'listening'
