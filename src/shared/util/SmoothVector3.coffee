
SmoothValue = require 'util/SmoothValue'

class SmoothVector3 extends SmoothValue
  constructor: (lerpTime, value, smoothness) ->
    super lerpTime, value, smoothness

  isSameTarget: (newTarget) ->
    diff = Math.abs(@target.x - newTarget.x) +
      Math.abs(@target.y - newTarget.y) +
      Math.abs(@target.z - newTarget.z)
    return diff < 0.001

  lerp: (a, b, x) ->
    return new THREE.Vector3(
      super(a.x, b.x, x),
      super(a.y, b.y, x),
      super(a.z, b.z, x)
    )


module.exports = SmoothVector3