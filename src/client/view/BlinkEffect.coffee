# each three mesh that is blinkable has the following functions:
# showBlinkEffect: name
# stopBlinkEffect: name
# toggleBlinkEffect: name, force (see dom-js::ClassList::toggle)
# addBlinkEffect: name, priority, options
# -> when two blink effects are active in parallel, the higher priority effect gets shown

PingPongValue = require 'util/PingPongValue'

loadBlinkEffect = (mesh) ->

  getMat = ->
    mat = mesh.material
    mat = mat[0] if mat[0]?
    return mat

  defaultEmissiveIntensity = getMat().emissiveIntensity
  defaultEmissiveColor = getMat().emissive.clone()


  effects = {}
  isActive = false

  getCurrentActiveEffect = ->
    currentActiveEffect = undefined
    for name, effect of effects
      if effect.enabled and (not currentActiveEffect? or effect.priority > currentActiveEffect.priority)
        currentActiveEffect = effect
    return currentActiveEffect

  blink = ->
    currentActiveEffect = getCurrentActiveEffect()
    unless currentActiveEffect?
      return stopBlinking()
    mat = getMat()
    blinkIntensity = currentActiveEffect.baseIntensity + currentActiveEffect.timer.get() * currentActiveEffect.intensityIncrease
    mat.emissiveIntensity = 1
    newEmissive = defaultEmissiveColor.clone().lerp new THREE.Color(currentActiveEffect.r, currentActiveEffect.g, currentActiveEffect.b), blinkIntensity
    mat.emissive = newEmissive

    window.requestAnimationFrame blink

  startBlinking = ->
    return if isActive
    isActive = true
    blink()

  stopBlinking = ->
    mat = getMat()
    mat.emissiveIntensity = defaultEmissiveIntensity
    mat.emissive = defaultEmissiveColor
    isActive = false



  showBlinkEffect = (name) ->
    return unless effects[name]?
    effects[name].enabled = true
    startBlinking()

  stopBlinkEffect = (name) ->
    return unless effects[name]?
    effects[name].enabled = false
    startBlinking()

  addBlinkEffect = (name, priority, options = {}) ->
    effects[name] =
      r: if options.r? then options.r else 1
      g: if options.g? then options.g else 1
      b: if options.b? then options.b else 0
      baseIntensity: options.baseIntensity or 0.05
      intensityIncrease: options.intensityIncrease or 0.1
      priority: priority
      enabled: false
      timer: new PingPongValue options.speed or 600, 2

  toggleBlinkEffect = (name, force) ->
    return unless effects[name]?
    if force?
      effects[name].enabled = force
    else
      effects[name].enabled = not effects[name].enabled
    startBlinking()



  mesh.userData.showBlinkEffect = showBlinkEffect
  mesh.userData.stopBlinkEffect = stopBlinkEffect
  mesh.userData.toggleBlinkEffect = toggleBlinkEffect
  mesh.userData.addBlinkEffect = addBlinkEffect

module.exports = loadBlinkEffect
