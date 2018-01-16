
SmoothValue = require 'util/SmoothValue'

class SmoothRotation extends SmoothValue
  constructor: (lerpTime, value, smoothness) ->
    super lerpTime, value, smoothness

  isSameTarget: (newTarget) ->
    diff = Math.abs(@target.x - newTarget.x) +
      Math.abs(@target.y - newTarget.y) +
      Math.abs(@target.z - newTarget.z) +
      Math.abs(@target.w - newTarget.w)
    return diff < 0.001

  lerp: (a, b, x) ->
    r = a.clone()
    r.slerp b, x
    return r


module.exports = SmoothRotation