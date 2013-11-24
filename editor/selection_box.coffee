define ["gl-matrix", "two/box", "two/shape_material", "two/color", "two/utils"], \
       (gl, Box, ShapeMaterial, Color, Utils) ->

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

      @_signals = options.signals
      @_scaleDirectionY = options.scaleDirectionY
      @_scaleDirectionX = options.scaleDirectionX

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
        signals: @_signals, overrides)

    getBoundingWidth: -> @width * 2
    getBoundingHeight: -> @height * 2

    attachTo: (object) ->
      @_object = object

    detach: ->
      @_object = null

    onActivated: ->
      @_initialScale = @_object.getScale()
      @_initialWidth = @getParent().getWidth()
      @_initialPosition = @getParent().getPosition()

    onDragged: (e) ->
      e.setWorldEndPoint(@_adjustStylusForUniformScale(e.worldEndPoint))

      worldTranslation = gl.vec2.clone(e.worldTranslation)

      worldTranslation[0] *= @_scaleDirectionX

      newScale = @_initialScale * (1 - worldTranslation[0]/@_initialWidth)
      @_object.setScale newScale
      @_object.setPosition [
        @_initialPosition[0] + @_scaleDirectionX*worldTranslation[0]/2,
        @_initialPosition[1] + @_scaleDirectionY*worldTranslation[0]/2
      ]

      @getParent().shrinkWrap @_object
      @_signals.gizmoChanged.dispatch @

    onStylusMoved: ->
      @_signals.cursorStyleChanged.dispatch @getName()

    _adjustStylusForUniformScale: (stylusPosition) ->
      boundingBox = @getParent().getBoundingBox()
      slope = boundingBox.getHeight() / boundingBox.getWidth()
      slope *= @_scaleDirectionX * @_scaleDirectionY

      stylusX = stylusPosition[0]
      stylusY = stylusPosition[1]

      snapX = 0.5*(stylusX + boundingBox.getX()) + (stylusY - boundingBox.getY())/(2*slope)
      snapY = slope*(snapX - boundingBox.getX()) + boundingBox.getY()

      [snapX, snapY]

  class SelectionBox extends Box
    constructor: (@_signals) ->
      options =
        material: new ShapeMaterial(strokeColor: SELECTION_COLOR, fillColor: SELECTION_FILL_COLOR)
        name: "selection-box"
      super options

      @_buildResizeHandles()

    attachTo: (object) ->
      @_object = object
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
      child.detach() for child in @getChildren()

    isAttached: ->
      @_object?

    _buildResizeHandles: ->
      largeHandle = new ResizeHandle
        width: LARGE_HANDLE_SIZE
        height: LARGE_HANDLE_SIZE
        signals: @_signals

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

    onStylusMoved: ->
      @_signals.cursorStyleChanged.dispatch "move"

    onDragged: (e) ->
      newPosition = gl.vec2.create()
      gl.vec2.add newPosition, e.worldTranslation, @_initialPosition

      @setPosition newPosition
      @_object.setPosition newPosition
      @_signals.gizmoChanged.dispatch @

    onActivated: ->
      @_initialPosition = @getPosition()

