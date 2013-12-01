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

      @inputBindings = new CommonInputBindings(@on)

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

      @_input = new EditorInput(@canvas, @inputBindings)
      @_listenForResize()

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

      gridPoint = [point[0]/@grid.getVerticalSize(), point[1]/@grid.getHorizontalSize()]

      switch mode
        when "nearest"
          [Math.round(gridPoint[0]), Math.round(gridPoint[1])]
        when "lower-left"
          [Math.floor(gridPoint[0]), Math.floor(gridPoint[1])]
        else point

    isGridSnappingEnabled: -> @_isGridSnappingEnabled

    _setCursor: (cursor) ->
      @$canvas.css "cursor", cursor

    _clearQuickTool: ->
      @_quickTool = null
      @getCurrentTool()?.onSelected()

    _listenForResize: ->
      oldWidth = @$domElement.width()
      oldHeight = @$domElement.height()

      window.setInterval (=>
        newWidth = @$domElement.width()
        newHeight = @$domElement.height()

        if oldWidth != newWidth || oldHeight != newHeight
          @renderer.resize newWidth, newHeight
          @camera.setAspectRatio @renderer.getWidth() / @renderer.getHeight()
          oldWidth = newWidth
          oldHeight = newHeight
          @render()
      ), 100

