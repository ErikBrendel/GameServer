webpack = require 'webpack'
config = require '../../webpack.config'

compiler = webpack config

watcher = compiler.watch
  aggregateTimeout: 300,
  (err, stats) ->
    console.log stats.toString
      colors: true