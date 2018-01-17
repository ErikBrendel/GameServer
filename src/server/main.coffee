http = require 'http'
WebSocket = require 'ws'
url = require 'url'
webpack = require './webpack'
optionList = require '../shared/util/OptionList'

app = require './app'
server = http.createServer app
wss = new WebSocket.Server {server}

apis = optionList require('./apis'), (ws) ->
  console.log "Received unknown ws request: #{location}"
  ws.send "BAD REQUEST: No API endpoint named #{location}"

wss.on 'connection', (ws, req) ->
  location = url.parse(req.url, true).path.substr 1
  apis[location] ws


server.listen process.env.PORT || 3000
server.on 'error', (err) ->
  console.error err.code
server.on 'listening', ->
  console.info 'listening'
