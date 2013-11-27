define (require) ->
  $ = require "jquery"
  Camera = require "two/camera"
  CanvasRenderer = require "two/canvas_renderer"
  Control = require "./lib/control"
  EditorInput = require "./editor_input"
  Grid = require "./grid"
  Projector = require "two/projector"
  Scene = require "two/scene"
  Signal = require "signals"

  class EditorBase extends Control
    constructor: ->
      super $("<div/>", class: "panel viewport")

      @maxCameraWidth = 1000
      @minCameraWidth = 1
      @zoomSpeed = 1
      @tools = []

      @on =
        cursorStyleChanged: new Signal()
        gizmoDeactivated: new Signal()
        gizmoDragged: new Signal()
        gridChanged: new Signal()
        gridSnappingChanged: new Signal()
        objectChanged: new Signal()
        objectDeselected: new Signal()
        objectSelected: new Signal()
        quickToolDeselected: new Signal()
        quickToolSelected: new Signal()
        stylusDragged: new Signal()
        stylusMoved: new Signal()
        stylusReleased: new Signal()
        stylusTouched: new Signal()
        toolSelected: new Signal()
        zoomLevelChanged: new Signal()

    run: ->
      @renderer = new CanvasRenderer
        width: @$domElement.width()
        height: @$domElement.height()
        autoClear: false

      @scene = new Scene()
      @sceneGizmos = new Scene()
      @sceneGrid = new Scene()
      @camera = new Camera(width: 15, aspectRatio: @renderer.getWidth() / @renderer.getHeight())
      @projector = new Projector(@camera, @renderer)

      @grid = @sceneGrid.add new Grid()

      @canvas = @renderer.domElement
      @$canvas = $(@canvas)
      @$domElement.html(@$canvas)

      new EditorInput(@on, @canvas)

      @on.cursorStyleChanged.add @onCursorStyleChanged, @

      # Set low priority so rendering is the last thing that happens after object change
      @on.objectChanged.add @onObjectChanged, @, -1
      @on.objectSelected.add @onObjectSelected, @, -1
      @on.objectDeselected.add @onObjectDeselected, @, -1

      @on.gridChanged.add @onGridChanged, @

      @on.quickToolDeselected.add @onQuickToolDeselected, @
      @on.quickToolSelected.add @onQuickToolSelected, @

      @on.stylusDragged.add @onStylusDragged, @
      @on.stylusMoved.add @onStylusMoved, @
      @on.stylusReleased.add @onStylusReleased, @
      @on.stylusTouched.add @onStylusTouched, @

      @on.toolSelected.add @onToolSelected, @

      @on.zoomLevelChanged.add @onZoomLevelChanged, @

    render: ->
      @renderer.clear()
      @renderer.render(@scene, @camera)
      @renderer.render(@sceneGrid, @camera)
      @renderer.render(@sceneGizmos, @camera)

    onZoomLevelChanged: (amount) ->
      width = @camera.getWidth()
      # Zoom speed gets faster the more zoomed out we are
      width -= amount*@zoomSpeed*width*0.6
      width = Math.min(width, @maxCameraWidth)
      width = Math.max(width, @minCameraWidth)

      @camera.setWidth(width)

      @render()

    onCursorStyleChanged: (newStyle) ->
      @_setCursor newStyle

    onObjectChanged: ->
      @render()

    onStylusMoved: (e) ->
      @getCurrentTool()?.onMoved(e)

    onStylusTouched: (e) ->
      @getCurrentTool()?.onActivated(e)

    onStylusDragged: (e) ->
      e.calculateWorldCoordinates(@projector)
      tool = @getCurrentTool()
      if tool?.isActive()
        tool.onDragged(e)

    onStylusReleased: (e) ->
      tool = @getCurrentTool()
      return unless tool

      tool.onDeactivated(e)

      if tool is @_quickTool && !tool.isSelected()
        @_clearQuickTool()

      return

    onObjectSelected: (object) ->
      @render()

    onObjectDeselected: ->
      @render()

    onGridChanged: (options) ->
      @render()

    onQuickToolDeselected: ->
      return unless @_quickTool?

      @_quickTool.onDeselected()

      unless @_quickTool.isActive()
        @_clearQuickTool()

    onQuickToolSelected: (which) ->
      quickTool = (t for t in @tools when t.name == which)[0]

      @_quickTool?.onDeselected() unless quickTool == @_quickTool
      @_quickTool = quickTool

      @_quickTool?.onSelected()

    onToolSelected: (which) ->
      tool = (t for t in @tools when t.name == which)[0]
      @_tool?.onDeselected() unless tool == @_tool
      @_tool = tool
      @_tool?.onSelected()

    getCurrentTool: ->
      @_quickTool || @_tool

    pickGizmo: (canvasPoint) ->
      @projector.pick(canvasPoint, @sceneGizmos)

    pickSceneObject: (canvasPoint) ->
      @projector.pick(canvasPoint, @scene)

    _setCursor: (cursor) ->
      @$canvas.css "cursor", cursor

    _clearQuickTool: ->
      @_quickTool = null
      @getCurrentTool()?.onSelected()
