express = require 'express'
path = require 'path'
http = require 'http'
https = require 'https'
coffee = require 'coffeescript'
fs = require 'fs'

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
                <title>[GameServer] #{game.gameType.name} - #{game.description}</title>
                <script type='text/javascript' src='/bundle/gameView/#{game.gameTypeName}.js'></script>
              </head></html>"


  app.get '/play_double/:gameId.html', (req, res) ->

    link = "/play/#{req.params.gameId}.html?#{req.url.split('?')[1]}"
    content = '<html><head><title>[GameServer] SplitScreen</title></head>' +
      '<frameset rows="50%,50%" border="0">' +
      "    <frame src='#{link}_top'>" +
      "    <frame src='#{link}_bottom'>" +
      '</frameset></html>'
    res.send content



  # all other static files
  app.use express.static path.join __dirname, '../../dist'

  return app
