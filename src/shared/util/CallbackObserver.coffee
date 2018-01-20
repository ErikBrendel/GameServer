# An observer that simply executes a callback

class CallbackObserver
  constructor: (@callback) ->

  registerOn: (observable, aspects...) ->
    observable.attachObserver @, @callback, aspects

  update: (notification, aspect) ->
    notification(aspect)

module.exports = CallbackObserver
