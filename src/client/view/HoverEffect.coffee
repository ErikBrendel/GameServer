loadBlinkEffect = require 'view/BlinkEffect'

loadHoverEffect = (mesh) ->
  unless mesh.userData.addBlinkEffect?
    loadBlinkEffect mesh

  mesh.userData.addBlinkEffect 'hover', 10,
    r: 1
    g: 1
    b: 0.5
    intensityIncrease: 0.1
    baseIntensity: 0.3
    speed: 600
  mesh.userData.mouseEnterHandler = -> mesh.userData.showBlinkEffect 'hover'
  mesh.userData.mouseLeaveHandler = -> mesh.userData.stopBlinkEffect 'hover'

module.exports = loadHoverEffect
