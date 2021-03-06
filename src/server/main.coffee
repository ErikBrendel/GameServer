http = require 'http'
WebSocket = require 'ws'
url = require 'url'
webpack = require './webpack'
optionList = require '../shared/util/OptionList'


MatchMaker = require './MatchMaker'
matchMaker = new MatchMaker


app = require('./app') matchMaker
server = http.createServer app
wss = new WebSocket.Server {server}

rawApis = require('./apis') matchMaker
apis = optionList rawApis, (ws, location) ->
  console.log "Received unknown ws request: #{location}"
  ws.send "BAD REQUEST: No API endpoint named #{location}"

wss.on 'connection', (ws, req) ->
  location = url.parse(req.url, true).path.substr 1
  apis[location] ws, location

port = process.env.PORT || 3000
server.listen port
server.on 'error', (err) ->
  console.error err.code
server.on 'listening', ->
  console.info "listening on port #{port}"

GameRegistry = require './GameRegistry'
games = GameRegistry.allGameTypeNames()
console.log "\n\nFound #{games.length} game(s):"
console.log "> #{typeName}" for typeName in games
console.log '\n'