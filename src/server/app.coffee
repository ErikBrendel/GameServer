express = require 'express'
path = require 'path'
http = require 'http'
https = require 'https'

MatchMaker = require './MatchMaker'

matchMaker = new MatchMaker

app = express()

app.use(express.urlencoded());

runningInProduction = process.env.NODE_ENV is "production"

if runningInProduction
  basicAuth = require 'basic-auth-connect'
  app.use basicAuth 'karl', 'potato'

host = if runningInProduction then 'gameServer.herokuapp.com' else 'localhost'
port = process.env.PORT || 3000

#
#    M A T C H M A K I N G
#


# matchmaking server list
app.get '/', (req, res) ->
  res.sendFile 'serverlist.html', { root: path.join(__dirname, '../../dist/') }


# all other static files
app.use express.static path.join __dirname, '../../dist'


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


module.exports =
  app: app
  matchMaker: matchMaker
  apis: apis
  port: port
