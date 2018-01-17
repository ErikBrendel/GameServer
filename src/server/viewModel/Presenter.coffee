# This class creates the presentation objects for
# Model classes

class Presenter
  constructor: (@game, @player) ->

  getInitialDataIds: ->
    return [] #TODO

  getPresentation: (dataId) ->
    return {} #TODO

  copy: (object) ->
    return undefined unless object?
    JSON.parse JSON.stringify object

module.exports = Presenter
