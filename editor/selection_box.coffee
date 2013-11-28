define (require) ->
  gl = require "gl-matrix"
  Box = require "two/box"
  ShapeMaterial = require "two/shape_material"
  Color = require "two/color"
  Disc = require "two/disc"
  Utils = require "two/utils"
  Styles = require "./styles"

  class SelectionBox extends Box
    constructor: (@on) ->
      options =
        material: new ShapeMaterial(strokeColor: Styles.SELECTION_COLOR, fillColor: Styles.SELECTION_FILL_COLOR)
        name: "selection-box"
      super options

      @on.objectChanged.add @_onObjectChanged, @
      @_buildResizeHandles()
      @_buildOriginPoint()

    attachTo: (object) ->
      @_object = object
      child.attachTo object for child in @getChildren()

      @shrinkWrap object

    shrinkWrap: (object) ->
      bounds = object.getBoundingBox()
      @setPosition bounds.getPosition()
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

      @_originMarker.setPosition object.getOrigin()

    detach: ->
      @_object = null
      child.detach() for child in @getChildren()

    isAttached: ->
      @_object?

    _buildResizeHandles: ->
      largeHandle = new ResizeHandle
        width: Styles.LARGE_HANDLE_SIZE
        height: Styles.LARGE_HANDLE_SIZE
        signals: @on

      smallHandle = largeHandle.clone(width: Styles.SMALL_HANDLE_SIZE, height: Styles.SMALL_HANDLE_SIZE)

      @_NEResizeHandle = @add(largeHandle.clone(
        name: "nesw-resize"
        scaleDirectionX: -1
        scaleDirectionY: -1
        pixelOffsetX: Styles.LARGE_HANDLE_PADDING
        pixelOffsetY: -Styles.LARGE_HANDLE_PADDING))

      @_NWResizeHandle = @add(largeHandle.clone(
        name: "nwse-resize"
        scaleDirectionX: 1
        scaleDirectionY: -1
        pixelOffsetX: -Styles.LARGE_HANDLE_PADDING
        pixelOffsetY: -Styles.LARGE_HANDLE_PADDING))

      @_SEResizeHandle = @add(largeHandle.clone(
        name: "nwse-resize"
        scaleDirectionX: -1
        scaleDirectionY: 1
        pixelOffsetX: Styles.LARGE_HANDLE_PADDING
        pixelOffsetY: Styles.LARGE_HANDLE_PADDING))

      @_SWResizeHandle = @add(largeHandle.clone(
        name: "nesw-resize"
        scaleDirectionX: 1
        scaleDirectionY: 1
        pixelOffsetX: -Styles.LARGE_HANDLE_PADDING
        pixelOffsetY: Styles.LARGE_HANDLE_PADDING))

      @_NResizeHandle = @add(smallHandle.clone(
        name: "ns-resize"
        pixelOffsetY: -Styles.SMALL_HANDLE_PADDING))

      @_EResizeHandle = @add(smallHandle.clone(
        name: "ew-resize"
        pixelOffsetX: Styles.SMALL_HANDLE_PADDING))

      @_SResizeHandle = @add(smallHandle.clone(
        name: "ns-resize"
        pixelOffsetY: Styles.SMALL_HANDLE_PADDING))

      @_WResizeHandle = @add(smallHandle.clone(
        name: "ew-resize"
        pixelOffsetX: -Styles.SMALL_HANDLE_PADDING))

    _buildOriginPoint: ->
      @_originMarker = @add new OriginMarker()

    onStylusMoved: ->
      @on.cursorStyleChanged.dispatch "move"

    onDragged: (e) ->
      newPosition = gl.vec2.create()
      gl.vec2.add newPosition, e.worldTranslation, @_initialPosition
      newPosition = e.editor.snapToGrid newPosition

      @setPosition newPosition
      @_object.setPosition newPosition
      @on.objectChanged.dispatch @_object

    onActivated: ->
      @_initialPosition = @_object.getPosition()

    _onObjectChanged: (object) ->
      @shrinkWrap object if object is @_object

  class ResizeHandle extends Box
    constructor: (options) ->
      options.material =
        new ShapeMaterial
          strokeColor: Styles.SELECTION_COLOR
          fillColor: "white"
          isFixedSize: true

      @on = options.signals
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
        signals: @on, overrides)

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
      @on.objectChanged.dispatch @_object

    onStylusMoved: ->
      @on.cursorStyleChanged.dispatch @getName()

    _adjustStylusForUniformScale: (stylusPosition) ->
      boundingBox = @getParent().getBoundingBox()
      slope = boundingBox.getHeight() / boundingBox.getWidth()
      slope *= @_scaleDirectionX * @_scaleDirectionY

      stylusX = stylusPosition[0]
      stylusY = stylusPosition[1]

      snapX = 0.5*(stylusX + boundingBox.getX()) + (stylusY - boundingBox.getY())/(2*slope)
      snapY = slope*(snapX - boundingBox.getX()) + boundingBox.getY()

      [snapX, snapY]

  class OriginMarker extends Disc
    constructor: ->
      super
        radius: 2
        material: new ShapeMaterial(
          fillColor: "white"
          strokeColor: Styles.SELECTION_COLOR
          isFixedSize: true)

    # TODO: this doesn't behave like a gizmo so we shouldn't need these methods
    attachTo: ->
    detach: ->
    onStylusMoved: ->

  return SelectionBox
