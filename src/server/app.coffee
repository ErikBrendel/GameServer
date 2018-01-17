express = require 'express'
path = require 'path'
http = require 'http'
https = require 'https'

app = express()

app.use express.urlencoded()

runningInProduction = process.env.NODE_ENV is 'production'

if runningInProduction
  basicAuth = require 'basic-auth-connect'
  app.use basicAuth 'karl', 'potato'

# all other static files
app.use express.static path.join __dirname, '../../dist'


module.exports = app
