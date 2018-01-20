
fs = require 'fs'

allGameTypeNamesList = undefined


allGameTypeNames = ->
  return allGameTypeNamesList if allGameTypeNamesList?

  allGameTypeNamesList = []

  gamesDir = "#{__dirname}/../../games/"
  fs.readdirSync(gamesDir).forEach (gamePackage) ->
    packageDir = "#{gamesDir}#{gamePackage}/"
    packageStat = fs.statSync packageDir
    if packageStat.isDirectory()
      fs.readdirSync(packageDir).forEach (game) ->
        gameDir = "#{packageDir}#{game}/"
        gameStat = fs.statSync gameDir
        if gameStat.isDirectory()
          gameMainFile = "#{gameDir}game.coffee"
          if fs.existsSync gameMainFile
            gameTypeName = "#{gamePackage}/#{game}"
            allGameTypeNamesList.push gameTypeName

  return allGameTypeNamesList

loadGameType = (type) ->
  return require "../../games/#{type}/game"

loadedGameTypes = {}

findGameType = (typeName) ->
  unless loadedGameTypes[typeName]?
    gameType = loadGameType typeName
    loadedGameTypes[typeName] = gameType
  return loadedGameTypes[typeName]

module.exports =
  findGameType: findGameType
  allGameTypeNames: allGameTypeNames
