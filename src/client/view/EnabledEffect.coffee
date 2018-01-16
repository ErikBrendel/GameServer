loadBlinkEffect = require 'view/BlinkEffect'

loadEnabledEffect = (mesh) ->
  unless mesh.userData.addBlinkEffect?
    loadBlinkEffect mesh

  mesh.userData.addBlinkEffect 'enabled', 5,
    r: 0.2
    g: 1
    b: 0.2
    intensityIncrease: 0.1
    baseIntensity: 0.2
    speed: 1500

module.exports = loadEnabledEffect
