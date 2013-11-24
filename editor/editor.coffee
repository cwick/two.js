define (require) ->
  $ = require "jquery"
  gl = require "gl-matrix"
  Box = require "two/box"
  Camera = require "two/camera"
  CanvasRenderer = require "two/canvas_renderer"
  Color = require "two/color"
  Disc = require "two/disc"
  EditorInput = require "./editor_input"
  Grid = require "./grid"
  Image = require "two/image"
  Inspector = require "./inspector"
  ShapeMaterial = require "two/shape_material"
  SpriteMaterial = require "two/sprite_material"
  Projector = require "two/projector"
  Scene = require "two/scene"
  SelectionBox = require "./selection_box"
  Signal = require "signals"
  Sprite = require "two/sprite"

  run: ->
    inspector = new Inspector(@on)
    $("#editor").append inspector.$domElement
    $viewport = $(".viewport")


    @renderer = new CanvasRenderer(width: $viewport.width(), height: $viewport.height(), autoClear: false)
    @scene = new Scene()
    @sceneGizmos = new Scene()
    @sceneGrid = new Scene()
    @camera = new Camera(width: 15, aspectRatio: @renderer.getWidth() / @renderer.getHeight())
    @projector = new Projector(@camera, @renderer)

    @scene.add new Disc(radius: 3, scale: 0.7, material: new ShapeMaterial(fillColor: "#BE0028"))
    @scene.add new Disc(x:5, y:-3, radius: 2, material: new ShapeMaterial(fillColor: "green"))
    @scene.add new Box(x:-5, y:-1, width: 4, height: 6, material: new ShapeMaterial(fillColor: "yellow", strokeColor: "red"))
    @scene.add new Sprite(width: 2, material: new SpriteMaterial(image: new Image("assets/mario.png", => @_render())))

    @sceneGrid.add new Grid()

    @canvas = @renderer.domElement
    @$canvas = $(@canvas)
    $viewport.append(@$canvas)

    @maxCameraWidth = 1000
    @minCameraWidth = 1
    @zoomSpeed = 1

    @_selectionBox = new SelectionBox(@on)
    @_render()

    new EditorInput(@on, @canvas)

    $("#show-grid").change (e) => @on.gridChanged.dispatch(isVisible: $(e.target).is(':checked'))
    $("#grab-tool").click => @on.grabToolSelected.dispatch()
    $("#new-sprite").click => @on.spriteCreated.dispatch()

    @on.cursorStyleChanged.add @_onCursorStyleChanged, @

    @on.objectChanged.add @_onObjectChanged, @

    @on.grabToolDeselected.add @_onGrabToolDeselected, @
    @on.grabToolDragged.add @_onGrabToolDragged, @
    @on.grabToolSelected.add @_onGrabToolSelected, @
    @on.grabToolStarted.add @_onGrabToolStarted, @
    @on.grabToolStopped.add @_onGrabToolStopped, @

    @on.gridChanged.add @_onGridChanged, @

    @on.objectDeselected.add @_onObjectDeselected, @
    @on.objectSelected.add @_onObjectSelected, @

    @on.stylusDragged.add @_onStylusDragged, @
    @on.stylusMoved.add @_onStylusMoved, @
    @on.stylusReleased.add @_onStylusReleased, @
    @on.stylusTouched.add @_onStylusTouched, @

    @on.spriteCreated.add @_onSpriteCreated, @
    @on.zoomLevelChanged.add @_onZoomLevelChanged, @

  on:
    cursorStyleChanged: new Signal()
    gizmoActivated: new Signal()
    gizmoDeactivated: new Signal()
    gizmoDragged: new Signal()
    grabToolDeselected: new Signal()
    grabToolSelected: new Signal()
    grabToolStarted: new Signal()
    grabToolStopped: new Signal()
    grabToolDragged: new Signal()
    gridChanged: new Signal()
    objectChanged: new Signal()
    objectDeselected: new Signal()
    objectSelected: new Signal()
    spriteCreated: new Signal()
    stylusDragged: new Signal()
    stylusMoved: new Signal()
    stylusReleased: new Signal()
    stylusTouched: new Signal()
    zoomLevelChanged: new Signal()

  _render: ->
    @renderer.clear()
    @renderer.render(@sceneGrid, @camera)
    @renderer.render(@scene, @camera)
    @renderer.render(@sceneGizmos, @camera)

  _onZoomLevelChanged: (amount) ->
    width = @camera.getWidth()
    # Zoom speed gets faster the more zoomed out we are
    width -= amount*@zoomSpeed*width*0.6
    width = Math.min(width, @maxCameraWidth)
    width = Math.max(width, @minCameraWidth)

    @camera.setWidth(width)

    @_updateCursorStyle()
    @_render()

  _onCursorStyleChanged: (newStyle) ->
    @_setCursor newStyle

  _onObjectChanged: ->
    @_render()

  _onStylusMoved: (e) ->
    @_stylusPosition = e.canvasPoint
    @_updateCursorStyle()

  _onStylusTouched: (e) ->
    if @_grabTool
      @on.grabToolStarted.dispatch()
    else
      @_activeGizmo = @_pickGizmo(e.canvasPoint)
      if @_activeGizmo?
        @_activeGizmo.onActivated()
        @on.gizmoActivated.dispatch @_activeGizmo

  _onStylusDragged: (e) ->
    @_stylusPosition = e.canvasEndPoint
    e.calculateWorldCoordinates(@projector)
    if @_grabbing
      @on.grabToolDragged.dispatch(e)
    else if @_activeGizmo?
      @_activeGizmo.onDragged(e)
      @on.gizmoDragged.dispatch @_activeGizmo

  _onStylusReleased: (e) ->
    if @_activeGizmo
      oldGizmo = @_activeGizmo
      @_activeGizmo = null
      @_updateCursorStyle()
      @on.gizmoDeactivated.dispatch oldGizmo
      return

    if @_grabbing
      @on.grabToolStopped.dispatch()
      return

    selectionThreshold = 2
    return unless e.isOnCanvas
    return if Math.abs(e.canvasTranslation[0]) > selectionThreshold ||
              Math.abs(e.canvasTranslation[1]) > selectionThreshold
    return if @projector.pick(e.canvasStartPoint, @sceneGizmos)?

    object = @projector.pick(e.canvasStartPoint, @scene)
    if object?
      @on.objectSelected.dispatch(object)
    else
      @on.objectDeselected.dispatch()

  _onObjectSelected: (object) ->
    unless @_selectionBox.isAttached()
      @sceneGizmos.add @_selectionBox

    @_selectionBox.attachTo object
    @_updateCursorStyle()
    @_render()

  _onObjectDeselected: ->
    @sceneGizmos.remove @_selectionBox
    @_selectionBox.detach()
    @_render()

  _onGrabToolStarted: ->
    @_grabbing = true
    @_initialCameraPosition = @camera.getPosition()

    @_setCursor "-webkit-grabbing"

  _onGrabToolStopped: (e) ->
    @_grabbing = false

    if @_grabTool
      @_setCursor "-webkit-grab"
    else
      @_setCursor "auto"

  _onGrabToolSelected: ->
    @_grabTool = true
    @_setCursor "-webkit-grab" unless @_grabbing

  _onGrabToolDeselected: ->
    @_grabTool = false
    @_setCursor "auto" unless @_grabbing

  _onGrabToolDragged: (e) ->
    newCameraPosition = gl.vec2.create()

    gl.vec2.subtract newCameraPosition, @_initialCameraPosition, e.worldTranslation

    @camera.setPosition newCameraPosition
    @_render()

  _onSpriteCreated: ->
    image = new Image "assets/default.png"
    sprite = new Sprite(material: new SpriteMaterial(image: image))

    image.loaded.add =>
      @scene.add sprite
      @on.objectSelected.dispatch sprite
      @_render()

  _setCursor: (cursor) ->
    @$canvas.css "cursor", cursor

  _onGridChanged: (options) ->
    o.setVisible(options.isVisible) for o in @sceneGrid.getChildren()
    @_render()

  _updateCursorStyle: ->
    return if @_grabTool || @_activeGizmo?
    return unless @_stylusPosition?
    gizmo = @_pickGizmo(@_stylusPosition, @sceneGizmos)
    if gizmo?
      gizmo.onStylusMoved()
    else
      @on.cursorStyleChanged.dispatch("auto")

  _pickGizmo: (canvasPoint) ->
    @projector.pick(canvasPoint, @sceneGizmos)

