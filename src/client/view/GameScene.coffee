# The GameScene encapsulates the three-stuff behind a running game

class GameScene
  constructor: (@updateCallback) ->
    @camera = new THREE.PerspectiveCamera(45, 1, 0.1, 100)
    @camera.position.z = 5
    @camera.position.y = 3

    @scene = new THREE.Scene()
    @scene.fog = new THREE.FogExp2 0x000000, 0.1

    ambiColor = '#ffffff'
    ambientLight = new THREE.AmbientLight ambiColor
    @scene.add ambientLight

    @renderer = new THREE.WebGLRenderer {antialias: true}
    @renderer.setClearColor 0x000000, 1

    @controls = new THREE.OrbitControls(@camera, @renderer.domElement)
    @controls.enableZoom = true

    @mouse = new THREE.Vector2()
    window.addEventListener 'mousemove', @onMouseMove, false
    window.addEventListener 'click', @onClick, false
    window.addEventListener 'wheel', @onMouseWheel, false
    @rayCaster = new THREE.Raycaster()
    @hoveredObjects = []

    #@ignoreShaderLogs()
    @resize()

    @lastHoveredObject = undefined

  ignoreShaderLogs: ->
    @renderer.context.getShaderInfoLog = () ->
      return ''

  addAxisHelper: (size) ->
    @scene.add new THREE.AxisHelper size

  resize: ->
    @resizeTo window.innerWidth, window.innerHeight
  resizeTo: (width, height) ->
    @camera.aspect = width / height
    @camera.updateProjectionMatrix()
    @renderer.setSize width, height

  appendChildToBody: ->
    @appendTo document.body
  appendTo: (elem) ->
    elem.appendChild @renderer.domElement

  animation: ->
    @hoverSceneObjects()

    @updateCallback()
    @renderer.render @scene, @camera

    window.requestAnimationFrame => @animation()

  onMouseMove: (event) =>
    # calculate mouse position in normalized device coordinates
    # (-1 to +1) for both components
    @mouse.x = event.clientX / window.innerWidth * 2 - 1
    @mouse.y = -(event.clientY / window.innerHeight) * 2 + 1
    @hoverSceneObjects()

  onMouseWheel: (event) =>
    @hoverSceneObjects()

  hoverSceneObjects: ->
    @rayCaster.setFromCamera @mouse, @camera
    @hoveredObjects = (res.object for res in (@rayCaster.intersectObjects @scene.children, true))
    hovered = @hoveredObjects[0]

    while hovered? and not (hovered.userData.mouseEnterHandler? or hovered.userData.mouseLeaveHandler?)
      hovered = hovered.parent

    if hovered isnt @lastHoveredObject
      @lastHoveredObject?.userData.mouseLeaveHandler?()
      hovered?.userData.mouseEnterHandler?()
      @lastHoveredObject = hovered

  onClick: (event) =>
    event.preventDefault()
    clicked = @hoveredObjects[0]
    return if not clicked?
    clicked.userData['clickHandler']?()

module.exports = GameScene
