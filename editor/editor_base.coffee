define (require) ->
  $ = require "jquery"
  gl = require "gl-matrix"
  Camera = require "two/camera"
  CanvasRenderer = require "two/canvas_renderer"
  Color = require "two/color"
  Dialog = require "./lib/dialog"
  EditorInput = require "./editor_input"
  Grid = require "./grid"
  Projector = require "two/projector"
  Scene = require "two/scene"
  Signal = require "signals"

  class EditorBase
    constructor: ->
      @on =
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
        gridSnappingChanged: new Signal()
        objectChanged: new Signal()
        objectDeselected: new Signal()
        objectSelected: new Signal()
        stylusDragged: new Signal()
        stylusMoved: new Signal()
        stylusReleased: new Signal()
        stylusTouched: new Signal()
        zoomLevelChanged: new Signal()

    run: ->
      $viewport = $(".viewport")

      @renderer = new CanvasRenderer(width: $viewport.width(), height: $viewport.height(), autoClear: false)
      @scene = new Scene()
      @sceneGizmos = new Scene()
      @sceneGrid = new Scene()
      @camera = new Camera(width: 15, aspectRatio: @renderer.getWidth() / @renderer.getHeight())
      @projector = new Projector(@camera, @renderer)

      @sceneGrid.add new Grid()

      @canvas = @renderer.domElement
      @$canvas = $(@canvas)
      $viewport.append(@$canvas)

      @maxCameraWidth = 1000
      @minCameraWidth = 1
      @zoomSpeed = 1

      @render()

      new EditorInput(@on, @canvas)

      @on.cursorStyleChanged.add @onCursorStyleChanged, @

      # Set low priority so rendering is the last thing that happens after object change
      @on.objectChanged.add @onObjectChanged, @, -1

      @on.grabToolDeselected.add @onGrabToolDeselected, @
      @on.grabToolDragged.add @onGrabToolDragged, @
      @on.grabToolSelected.add @onGrabToolSelected, @
      @on.grabToolStarted.add @onGrabToolStarted, @
      @on.grabToolStopped.add @onGrabToolStopped, @

      @on.gridChanged.add @onGridChanged, @

      @on.objectSelected.add @onObjectSelected, @, -1
      @on.objectDeselected.add @onObjectDeselected, @, -1

      @on.stylusDragged.add @onStylusDragged, @
      @on.stylusMoved.add @onStylusMoved, @
      @on.stylusReleased.add @onStylusReleased, @
      @on.stylusTouched.add @onStylusTouched, @

      @on.zoomLevelChanged.add @onZoomLevelChanged, @

    render: ->
      @renderer.clear()
      @renderer.render(@sceneGrid, @camera)
      @renderer.render(@scene, @camera)
      @renderer.render(@sceneGizmos, @camera)

    onZoomLevelChanged: (amount) ->
      width = @camera.getWidth()
      # Zoom speed gets faster the more zoomed out we are
      width -= amount*@zoomSpeed*width*0.6
      width = Math.min(width, @maxCameraWidth)
      width = Math.max(width, @minCameraWidth)

      @camera.setWidth(width)

      @_updateCursorStyle()
      @render()

    onCursorStyleChanged: (newStyle) ->
      @_setCursor newStyle

    onObjectChanged: ->
      @render()

    onStylusMoved: (e) ->
      @_stylusPosition = e.canvasPoint
      @_updateCursorStyle()

    onStylusTouched: (e) ->
      if @_grabTool
        @on.grabToolStarted.dispatch()
      else
        @_activeGizmo = @_pickGizmo(e.canvasPoint)
        if @_activeGizmo?
          @_activeGizmo.onActivated()
          @on.gizmoActivated.dispatch @_activeGizmo

    onStylusDragged: (e) ->
      @_stylusPosition = e.canvasEndPoint
      e.calculateWorldCoordinates(@projector)
      if @_grabbing
        @on.grabToolDragged.dispatch(e)
      else if @_activeGizmo?
        @_activeGizmo.onDragged(e)
        @on.gizmoDragged.dispatch @_activeGizmo

    onStylusReleased: (e) ->
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

    onGrabToolStarted: ->
      @_grabbing = true
      @_initialCameraPosition = @camera.getPosition()

      @_setCursor "-webkit-grabbing"

    onGrabToolStopped: (e) ->
      @_grabbing = false

      if @_grabTool
        @_setCursor "-webkit-grab"
      else
        @_setCursor "auto"

    onGrabToolSelected: ->
      return if @_activeGizmo?

      @_grabTool = true
      @_setCursor "-webkit-grab" unless @_grabbing

    onGrabToolDeselected: ->
      return if @_activeGizmo?

      @_grabTool = false
      @_setCursor "auto" unless @_grabbing

    onGrabToolDragged: (e) ->
      newCameraPosition = gl.vec2.create()

      gl.vec2.subtract newCameraPosition, @_initialCameraPosition, e.worldTranslation

      @camera.setPosition newCameraPosition
      @render()

    onObjectSelected: (object) ->
      @_updateCursorStyle()
      @render()

    onObjectDeselected: ->
      EditorBase::onObjectSelected.apply @, arguments

    onGridChanged: (options) ->
      o.setVisible(options.isVisible) for o in @sceneGrid.getChildren()
      @render()

    _setCursor: (cursor) ->
      @$canvas.css "cursor", cursor

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

