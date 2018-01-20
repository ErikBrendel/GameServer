
findAllGameIds = ->
  [ 'test/void' ] #TODO scan files

loadGameType = (type) ->
  return require "../../games/#{type}/game"

loadedGameTypes = {}

findGameType = (type) ->
  unless loadedGameTypes[type]?
    gameType = loadGameType type
    loadedGameTypes[type] = gameType
  return loadedGameTypes[type]

module.exports =
  findGameType: findGameType
  findAllGameIds: findAllGameIds
