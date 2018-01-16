express = require 'express'
path = require 'path'
http = require 'http'
https = require 'https'

MatchMaker = require './MatchMaker'

matchMaker = new MatchMaker
matchMaker.createGame 'auto-generated game'

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


app.get '/createNewGame.html', (req, res) ->
  matchMaker.createGame()
  res.send 'ok'

app.post '/deleteGame.html', (req, res) ->
  matchMaker.deleteGame req.body.gameId
  res.send 'ok'


# matchmaking server list
app.get '/', (req, res) ->
  res.sendFile 'serverlist.html', { root: path.join(__dirname, '../../dist/') }


# all other static files
app.use express.static path.join __dirname, '../../dist'

module.exports =
  app: app
  matchMaker: matchMaker
  port: port
