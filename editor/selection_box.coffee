define ["gl-matrix", "two/box", "two/shape_material", "two/color", "./mouse_buttons", "two/utils"], \
       (gl, Box, ShapeMaterial, Color, MouseButtons, Utils) ->

  SELECTION_COLOR = new Color(r: 20, g: 0, b: 229)
  SELECTION_FILL_COLOR = SELECTION_COLOR.clone(a: 0.1)
  LARGE_HANDLE_SIZE = 10
  LARGE_HANDLE_PADDING = 12
  SMALL_HANDLE_SIZE = LARGE_HANDLE_SIZE / 2 + 2
  SMALL_HANDLE_PADDING = LARGE_HANDLE_PADDING - SMALL_HANDLE_SIZE/2 + 2

  class ResizeHandle extends Box
    constructor: (options) ->
      options.material =
        new ShapeMaterial
          strokeColor: SELECTION_COLOR
          fillColor: "white"
          isFixedSize: true

      @_signalBindings = []
      @_projector = options.projector
      @_signals = options.signals
      @_scaleDirectionY = options.scaleDirectionY
      @_scaleDirectionX = options.scaleDirectionX

      delete options.projector
      delete options.signals
      delete options.scaleDirectionX
      delete options.scaleDirectionY

      super options

    clone: (overrides) ->
      new ResizeHandle(@cloneProperties overrides)

    cloneProperties: (overrides) ->
      super Utils.merge(
        scaleDirectionX: @_scaleDirectionX
        scaleDirectionY: @_scaleDirectionY
        projector: @_projector
        signals: @_signals, overrides)

    getBoundingWidth: -> @width * 2
    getBoundingHeight: -> @height * 2

    attachTo: (object) ->
      @detach()
      @_object = object
      @_attachSignalHandlers()

    detach: ->
      @_object = null
      @_detachSignalHandlers()

    _attachSignalHandlers: ->
      priority = 1
      # @_signalBindings.push @_signals.mouseMoved.add(@_onMouseMoved, @, priority)
      # @_signalBindings.push @_signals.mouseButtonPressed.add(@_onMouseButtonPressed, @ , priority)
      # @_signalBindings.push @_signals.mouseButtonReleased.add(@_onMouseButtonReleased, @ , priority)
      # @_signalBindings.push @_signals.keyPressed.add(@_onKeyPressed, @ , priority)
      # @_signalBindings.push @_signals.keyReleased.add(@_onKeyReleased, @ , priority)

    _detachSignalHandlers: ->
      binding.detach() for binding in @_signalBindings

    _onMouseButtonPressed: (e) ->
      if e.which == MouseButtons.LEFT && e.gizmo is @
        @_anchorPoint = @_projector.unproject gl.vec2.fromValues(e.pageX, e.pageY)
        @_initialScale = @_object.getScale()
        @_initialWidth = @getParent().getWidth()
        @_initialPosition = @getParent().getPosition()
        return false
      else
        return true

    _onMouseButtonReleased: (e) ->
      if e.which == MouseButtons.LEFT
        @_anchorPoint = null

      return true

    onStylusMoved: ->
      # return true if e.activeGizmo? and e.activeGizmo isnt @

      # if e.activeGizmo is @
      #   movePoint = @_projector.unproject gl.vec2.fromValues(e.pageX, e.pageY)
      #   moveVector = gl.vec2.create()
      #   gl.vec2.subtract moveVector, movePoint, @_anchorPoint

      #   moveVector[0] *= @_scaleDirectionX

      #   newScale = @_initialScale * (1 - moveVector[0]/@_initialWidth)
      #   @_object.setScale newScale
      #   @_object.setPosition [
      #     @_initialPosition[0] + @_scaleDirectionX*moveVector[0]/2,
      #     @_initialPosition[1] + @_scaleDirectionY*moveVector[0]/2
      #   ]

      #   @getParent().shrinkWrap @_object
      #   @_signals.gizmoChanged.dispatch @
      #   return false

      # else if e.gizmo is @
      @_signals.cursorStyleChanged.dispatch @getName()

    _onKeyPressed: (e) -> return false if e.activeGizmo is @
    _onKeyReleased: (e) -> return false if e.activeGizmo is @

  class SelectionBox extends Box
    constructor: (@_signals, @_projector) ->
      options =
        material: new ShapeMaterial(strokeColor: SELECTION_COLOR, fillColor: SELECTION_FILL_COLOR)
        name: "selection-box"
      super options

      @_signalBindings = []
      @_buildResizeHandles()

    attachTo: (object) ->
      @detach()
      @_object = object
      @_attachSignalHandlers()
      child.attachTo object for child in @getChildren()

      @shrinkWrap object

    shrinkWrap: (object) ->
      bounds = object.getBoundingBox()
      @setPosition object.getPosition()
      @setWidth bounds.getWidth()
      @setHeight bounds.getHeight()

      @_NEResizeHandle.setPosition [bounds.getWidth()/2, bounds.getHeight()/2]
      @_NWResizeHandle.setPosition [-bounds.getWidth()/2, bounds.getHeight()/2]
      @_SEResizeHandle.setPosition [bounds.getWidth()/2, -bounds.getHeight()/2]
      @_SWResizeHandle.setPosition [-bounds.getWidth()/2, -bounds.getHeight()/2]

      @_NResizeHandle.setY(bounds.getHeight()/2)
      @_EResizeHandle.setX(bounds.getWidth()/2)
      @_SResizeHandle.setY(-bounds.getHeight()/2)
      @_WResizeHandle.setX(-bounds.getWidth()/2)

    detach: ->
      @_object = null
      @_detachSignalHandlers()
      child.detach() for child in @getChildren()

    isAttached: ->
      @_object?

    _attachSignalHandlers: ->
      priority = 1
      # @_signalBindings.push @_signals.mouseMoved.add(@_onMouseMoved, @, priority)
      # @_signalBindings.push @_signals.mouseButtonPressed.add(@_onMouseButtonPressed, @ , priority)
      # @_signalBindings.push @_signals.mouseButtonReleased.add(@_onMouseButtonReleased, @ , priority)
      # @_signalBindings.push @_signals.keyPressed.add(@_onKeyPressed, @ , priority)
      # @_signalBindings.push @_signals.keyReleased.add(@_onKeyReleased, @ , priority)

      child._attachSignalHandlers() for child in @getChildren()

    _detachSignalHandlers: ->
      binding.detach() for binding in @_signalBindings
      child._detachSignalHandlers() for child in @getChildren()

    _buildResizeHandles: ->
      largeHandle = new ResizeHandle
        width: LARGE_HANDLE_SIZE
        height: LARGE_HANDLE_SIZE
        signals: @_signals
        projector: @_projector

      smallHandle = largeHandle.clone(width: SMALL_HANDLE_SIZE, height: SMALL_HANDLE_SIZE)

      @add(@_NEResizeHandle = largeHandle.clone(
        name: "nesw-resize"
        scaleDirectionX: -1
        scaleDirectionY: -1
        pixelOffsetX: LARGE_HANDLE_PADDING
        pixelOffsetY: -LARGE_HANDLE_PADDING))

      @add(@_NWResizeHandle = largeHandle.clone(
        name: "nwse-resize"
        scaleDirectionX: 1
        scaleDirectionY: -1
        pixelOffsetX: -LARGE_HANDLE_PADDING
        pixelOffsetY: -LARGE_HANDLE_PADDING))

      @add(@_SEResizeHandle = largeHandle.clone(
        name: "nwse-resize"
        scaleDirectionX: -1
        scaleDirectionY: 1
        pixelOffsetX: LARGE_HANDLE_PADDING
        pixelOffsetY: LARGE_HANDLE_PADDING))

      @add(@_SWResizeHandle = largeHandle.clone(
        name: "nesw-resize"
        scaleDirectionX: 1
        scaleDirectionY: 1
        pixelOffsetX: -LARGE_HANDLE_PADDING
        pixelOffsetY: LARGE_HANDLE_PADDING))

      @add(@_NResizeHandle = smallHandle.clone(
        name: "ns-resize"
        pixelOffsetY: -SMALL_HANDLE_PADDING))

      @add(@_EResizeHandle = smallHandle.clone(
        name: "ew-resize"
        pixelOffsetX: SMALL_HANDLE_PADDING))

      @add(@_SResizeHandle = smallHandle.clone(
        name: "ns-resize"
        pixelOffsetY: SMALL_HANDLE_PADDING))

      @add(@_WResizeHandle = smallHandle.clone(
        name: "ew-resize"
        pixelOffsetX: -SMALL_HANDLE_PADDING))

    _onMouseButtonPressed: (e) ->
      if e.which == MouseButtons.LEFT && e.gizmo is @
        @_anchorPoint = @_projector.unproject gl.vec2.fromValues(e.pageX, e.pageY)
        @_initialPosition = @getPosition()
        return false
      else
        return true

    _onMouseButtonReleased: (e) ->
      if e.which == MouseButtons.LEFT
        @_anchorPoint = null

      return true

    onStylusMoved: ->
      @_signals.cursorStyleChanged.dispatch "move"

    _onKeyPressed: (e) ->
      return false if e.activeGizmo is @

    _onKeyReleased: (e) ->
      return false if e.activeGizmo is @

    _moveSelectionBox: (e) ->
      movePoint = @_projector.unproject gl.vec2.fromValues(e.pageX, e.pageY)
      moveVector = gl.vec2.create()
      newPosition = gl.vec2.create()
      gl.vec2.subtract moveVector, movePoint, @_anchorPoint
      gl.vec2.add newPosition, moveVector, @_initialPosition
      @setPosition newPosition
      @_object.setPosition newPosition
      @_signals.gizmoChanged.dispatch @

