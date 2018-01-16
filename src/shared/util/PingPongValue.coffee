# a value that goes from 0 to 1 and back, forever

SmoothValue = require './SmoothValue'

class PingPongValue
  constructor: (@lerpTime, @smoothness = 1) ->
    @startTime = Date.now()

  get: ->
    timePassed = Date.now() - @startTime
    normalized = timePassed % (@lerpTime * 2)
    if normalized > @lerpTime
      normalized = 2 * @lerpTime - normalized
    rawResult = normalized / @lerpTime
    return SmoothValue.smoothValue rawResult, @smoothness

module.exports = PingPongValue
