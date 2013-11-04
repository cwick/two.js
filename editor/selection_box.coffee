define ["gl-matrix", "two/box", "two/material", "two/color", "./mouse_buttons"], \
       (gl, Box, Material, Color, MouseButtons) ->

  SELECTION_COLOR = new Color(r: 20, g: 0, b: 229)
  SELECTION_FILL_COLOR = SELECTION_COLOR.clone(a: 0.1)
  LARGE_HANDLE_SIZE = 10
  LARGE_HANDLE_PADDING = 12
  SMALL_HANDLE_SIZE = LARGE_HANDLE_SIZE / 2 + 2
  SMALL_HANDLE_PADDING = LARGE_HANDLE_PADDING - SMALL_HANDLE_SIZE/2 + 2

  class ResizeHandle extends Box
    constructor: (options) ->
      options.material =
        new Material
          strokeColor: SELECTION_COLOR
          fillColor: "white"
          isFixedSize: true

      super options

    clone: (overrides) ->
      new ResizeHandle(@cloneProperties overrides)

    getBoundingWidth: -> @width * 2
    getBoundingHeight: -> @height * 2


  class SelectionBox extends Box
    constructor: (@_signals, @_projector) ->
      options =
        material: new Material(strokeColor: SELECTION_COLOR, fillColor: SELECTION_FILL_COLOR)
        name: "selection-box"
      super options

      @_signalBindings = []
      @_buildResizeHandles()

    attachTo: (object) ->
      @detach()
      @_object = object
      @_attachSignalHandlers()

      bounds = @_object.getBoundingBox()
      @setPosition @_object.getPosition()
      @width = bounds.getWidth()
      @height = bounds.getHeight()

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

    isAttached: ->
      @_object?

    _attachSignalHandlers: ->
      priority = 1
      @_signalBindings.push @_signals.mouseMoved.add(@_onMouseMoved, @, priority)
      @_signalBindings.push @_signals.mouseButtonPressed.add(@_onMouseButtonPressed, @ , priority)
      @_signalBindings.push @_signals.mouseButtonReleased.add(@_onMouseButtonReleased, @ , priority)
      @_signalBindings.push @_signals.keyPressed.add(@_onKeyPressed, @ , priority)
      @_signalBindings.push @_signals.keyReleased.add(@_onKeyReleased, @ , priority)

    _detachSignalHandlers: ->
      binding.detach() for binding in @_signalBindings

    _buildResizeHandles: ->
      largeHandle = new ResizeHandle
        width: LARGE_HANDLE_SIZE
        height: LARGE_HANDLE_SIZE

      smallHandle = largeHandle.clone()
      smallHandle.width = smallHandle.height = SMALL_HANDLE_SIZE

      @add(@_NEResizeHandle = largeHandle.clone(
        name: "nesw-resize"
        pixelOffsetX: LARGE_HANDLE_PADDING
        pixelOffsetY: -LARGE_HANDLE_PADDING))

      @add(@_NWResizeHandle = largeHandle.clone(
        name: "nwse-resize"
        pixelOffsetX: -LARGE_HANDLE_PADDING
        pixelOffsetY: -LARGE_HANDLE_PADDING))

      @add(@_SEResizeHandle = largeHandle.clone(
        name: "nwse-resize"
        pixelOffsetX: LARGE_HANDLE_PADDING
        pixelOffsetY: LARGE_HANDLE_PADDING))

      @add(@_SWResizeHandle = largeHandle.clone(
        name: "nesw-resize"
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

    _onMouseButtonPressed: (e, gizmo) ->
      if e.which == MouseButtons.LEFT && gizmo is @
        @_moving = true
        @_moveAnchor = @_projector.unproject gl.vec2.fromValues(e.pageX, e.pageY)
        @_initialPosition = @getPosition()
        return false
      else
        return true

    _onMouseButtonReleased: (e, gizmo) ->
      if e.which == MouseButtons.LEFT
        @_moving = false
        @_moveAnchor = null

      return true

    _onMouseMoved: (e, gizmo) ->
      if @_moving
        movePoint = @_projector.unproject gl.vec2.fromValues(e.pageX, e.pageY)
        moveVector = gl.vec2.create()
        newPosition = gl.vec2.create()
        gl.vec2.subtract moveVector, movePoint, @_moveAnchor
        gl.vec2.add newPosition, moveVector, @_initialPosition
        @setPosition newPosition
        @_signals.gizmoChanged.dispatch @
        return false

      if gizmo is @
        @_signals.cursorStyleChanged.dispatch "move"
        return false
      else if gizmo in @getChildren()
        @_signals.cursorStyleChanged.dispatch gizmo.getName()
        return false
      else
        return true

    _onKeyPressed: (e) ->
      return false if @_moving

    _onKeyReleased: (e) ->
      return false if @_moving
