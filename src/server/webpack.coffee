webpack = require 'webpack'
config = require '../../webpack.config'
GameRegistry = require './GameRegistry'


# adding games to webpack
for gameTypeName in GameRegistry.allGameTypeNames()
  config.entry["gameView/#{gameTypeName}"] = "#{gameTypeName}/view.coffee"

compiler = webpack config

watcher = compiler.watch
  aggregateTimeout: 500,
  (err, stats) ->
    console.log stats.toString
      colors: true