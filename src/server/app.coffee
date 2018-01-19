express = require 'express'
path = require 'path'
http = require 'http'
https = require 'https'


module.exports = (matchMaker) ->

  app = express()

  app.use express.urlencoded()

  runningInProduction = process.env.NODE_ENV is 'production'

  if runningInProduction
    basicAuth = require 'basic-auth-connect'
    app.use basicAuth 'karl', 'potato'


  app.get '/play/:gameId.html', (req, res) ->

    gameId = req.params.gameId
    game = matchMaker.games[gameId]
    return res.send "<b>There is no game with id #{gameId}!</b>" unless game?

    res.header 'Content-Type', 'text/html'
    res.send "<html><head>
                <title>#{game.gameType.name} - #{game.description}</title>
                <script type='text/javascript' src='/gameView/#{game.gameTypeName}.js'></script>
              </head></html>"


  app.get '/gameView/:gamePackage/:gameName.js', (req, res) ->
    gameTypeName = "#{req.params.gamePackage}/#{req.params.gameName}"
    res.send "alert('JS file of #{gameTypeName} is there!');"



  # all other static files
  app.use express.static path.join __dirname, '../../dist'

  return app
