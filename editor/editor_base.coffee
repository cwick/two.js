define (require) ->
  $ = require "jquery"
  Camera = require "two/camera"
  CanvasRenderer = require "two/canvas_renderer"
  CommonInputBindings = require "./common_input_bindings"
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
      @tools = []

      _createEvents.call @
      _addEventListeners.call @
      _prepareScene.call @
      window.setTimeout (=> _listenForResize.call @), 0

      @inputBindings = new CommonInputBindings(@on)
      @grid = @sceneGrid.add new Grid()


      @_input = new EditorInput(@canvas, @inputBindings)

    render: ->
      return if @_isRenderPending

      @_isRenderPending = true
      window.setTimeout (=>
        @_renderScenes()
        @_isRenderPending = false), 0

    getStylusPosition: ->
      e = @_input.getStylusPosition()
      e.worldPoint = @projector.unproject e.canvasPoint
      e

    _renderScenes: ->
      @renderer.clear()
      @renderer.render(@scene, @camera)
      @renderer.render(@sceneGrid, @camera)
      @renderer.render(@sceneGizmos, @camera)

    onCursorStyleChanged: (newStyle) ->
      @_setCursor newStyle

    onObjectChanged: ->
      @render()

    onStylusMoved: (e) ->
      e.worldPoint = @projector.unproject(e.canvasPoint)
      @getCurrentTool()?.onMoved(e)

    onStylusTouched: (e) ->
      e.worldPoint = @projector.unproject(e.canvasPoint)
      tool = @getCurrentTool()
      if tool?
        @on.toolActivated.dispatch tool.name, e

    onStylusDragged: (e) ->
      e.calculateWorldCoordinates(@projector)
      e.editor = @
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

    onStylusEntered: ->
      @getCurrentTool()?.onEnteredCanvas()

    onStylusLeft: ->
      @getCurrentTool()?.onLeftCanvas()

    onObjectSelected: (object) ->
      @selectedObject = object
      @render()

    onObjectDeselected: ->
      @render()

    onGridChanged: (options) ->
      if options.isVisible?
        @grid.setVisible options.isVisible

      if options.horizontalSize?
        @grid.setHorizontalSize options.horizontalSize

      if options.verticalSize?
        @grid.setVerticalSize options.verticalSize

      @grid.build()
      @render()

    onGridSnappingChanged: (isEnabled) ->
      @_isGridSnappingEnabled = isEnabled

    onQuickToolDeselected: ->
      return unless @_quickTool?

      @_quickTool.onDeselected()

      unless @_quickTool.isActive()
        @_clearQuickTool()

    onQuickToolSelected: (which) ->
      return if @getCurrentTool()?.isActive()
      quickTool = @getTool(which)

      @_quickTool?.onDeselected() unless quickTool == @_quickTool
      @_quickTool = quickTool

      @_quickTool?.onSelected()

    onToolSelected: (which) ->
      tool = @getTool(which)
      @_tool?.onDeselected() unless tool == @_tool
      @_tool = tool
      @_tool?.onSelected()

    onToolActivated: (which, e) ->
      tool = @getTool(which)
      if tool?
        tool.onActivated(e)

    onToolApplied: (which, options) ->
      tool = @getTool(which)
      if tool?
        tool[which](options)

    getTool: (name) ->
      (t for t in @tools when t.name == name)[0]

    getCurrentTool: ->
      @_quickTool || @_tool

    pickGizmo: (canvasPoint) ->
      @projector.pick(canvasPoint, @sceneGizmos)

    pickSceneObject: (canvasPoint) ->
      @projector.pick(canvasPoint, @scene)

    snapToGrid: (point, mode="nearest") ->
      return point unless @_isGridSnappingEnabled

      @grid.snap point, mode

    isGridSnappingEnabled: -> @_isGridSnappingEnabled

    resizeCanvas: ->
      @renderer.resize @$domElement.width(), @$domElement.height()
      @camera.setAspectRatio @renderer.getWidth() / @renderer.getHeight()
      @render()

    _setCursor: (cursor) ->
      $(@canvas).css "cursor", cursor

    _clearQuickTool: ->
      @_quickTool = null
      @getCurrentTool()?.onSelected()

  _listenForResize = ->
    oldWidth = @$domElement.width()
    oldHeight = @$domElement.height()

    window.setInterval (=>
      newWidth = @$domElement.width()
      newHeight = @$domElement.height()

      if oldWidth != newWidth || oldHeight != newHeight
        @resizeCanvas()
        oldWidth = newWidth
        oldHeight = newHeight
    ), 100

  _prepareScene = ->
    @renderer = new CanvasRenderer
      width: 0
      height: 0
      autoClear: false

    @canvas = @renderer.domElement
    @$domElement.html(@canvas)
    @scene = new Scene()
    @sceneGizmos = new Scene()
    @sceneGrid = new Scene()
    @camera = new Camera(width: 15)
    @projector = new Projector(@camera, @renderer)
    @resizeCanvas()

  _createEvents = ->
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
      stylusEntered: new Signal()
      stylusLeft: new Signal()
      stylusMoved: new Signal()
      stylusReleased: new Signal()
      stylusTouched: new Signal()
      toolActivated: new Signal()
      toolApplied: new Signal()
      toolSelected: new Signal()

  _addEventListeners = ->
    @on.cursorStyleChanged.add @onCursorStyleChanged, @

    @on.objectChanged.add @onObjectChanged, @
    @on.objectSelected.add @onObjectSelected, @
    @on.objectDeselected.add @onObjectDeselected, @

    @on.gridChanged.add @onGridChanged, @
    @on.gridSnappingChanged.add @onGridSnappingChanged, @

    @on.quickToolDeselected.add @onQuickToolDeselected, @
    @on.quickToolSelected.add @onQuickToolSelected, @

    @on.stylusDragged.add @onStylusDragged, @
    @on.stylusMoved.add @onStylusMoved, @
    @on.stylusReleased.add @onStylusReleased, @
    @on.stylusTouched.add @onStylusTouched, @
    @on.stylusEntered.add @onStylusEntered, @
    @on.stylusLeft.add @onStylusLeft, @

    @on.toolSelected.add @onToolSelected, @
    @on.toolActivated.add @onToolActivated, @
    @on.toolApplied.add @onToolApplied, @

  return EditorBase
