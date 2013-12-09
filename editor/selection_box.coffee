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
        verticalResizeFactor: 1
        pixelOffsetY: -Styles.SMALL_HANDLE_PADDING))

      @_EResizeHandle = @add(smallHandle.clone(
        name: "ew-resize"
        horizontalResizeFactor: 1
        pixelOffsetX: Styles.SMALL_HANDLE_PADDING))

      @_SResizeHandle = @add(smallHandle.clone(
        name: "ns-resize"
        verticalResizeFactor: -1
        pixelOffsetY: Styles.SMALL_HANDLE_PADDING))

      @_WResizeHandle = @add(smallHandle.clone(
        name: "ew-resize"
        horizontalResizeFactor: -1
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
      @_horizontalResizeFactor = options.horizontalResizeFactor ?= 0
      @_verticalResizeFactor = options.verticalResizeFactor ?= 0

      delete options.signals
      delete options.horizontalResizeFactor

      super options

    clone: (overrides) ->
      new ResizeHandle(@cloneProperties overrides)

    cloneProperties: (overrides) ->
      super Utils.merge(
        horizontalResizeFactor: @_horizontalResizeFactor
        verticalResizeFactor: @_verticalResizeFactor
        signals: @on, overrides)

    getBoundingWidth: -> @getWidth() * 2
    getBoundingHeight: -> @getHeight() * 2

    attachTo: (object) ->
      @_object = object

    detach: ->
      @_object = null

    onActivated: ->
      @_initialWidth = @_object.getWidth()
      @_initialHeight = @_object.getHeight()
      @_initialPosition = @_object.getPosition()
      @_initialOrigin = @_object.getOrigin()

    onDragged: (e) ->
      newPosition = gl.vec2.create()
      newOrigin = gl.vec2.create()

      newWidth = @_initialWidth + e.worldTranslation[0]*@_horizontalResizeFactor
      newHeight = @_initialHeight + e.worldTranslation[1]*@_verticalResizeFactor
      [newWidth, newHeight] = e.editor.snapToGrid [newWidth, newHeight]

      newOrigin[0] = @_initialOrigin[0]*newWidth / @_initialWidth
      newPosition[0] = @_initialPosition[0] +
        Math.abs(@_horizontalResizeFactor) *
        @_horizontalResizeFactor*(newWidth - @_initialWidth) *
        (0.5 + @_horizontalResizeFactor*@_initialOrigin[0]/@_initialWidth)

      newOrigin[1] = @_initialOrigin[1]*newHeight / @_initialHeight
      newPosition[1] = @_initialPosition[1] +
        Math.abs(@_verticalResizeFactor) *
        @_verticalResizeFactor*(newHeight - @_initialHeight) *
        (0.5 + @_verticalResizeFactor*@_initialOrigin[1]/@_initialHeight)

      @_object.setSize newWidth, newHeight
      @_object.setOrigin newOrigin
      @_object.setPosition newPosition
      @getParent().shrinkWrap @_object
      @on.objectChanged.dispatch @_object

    onStylusMoved: ->
      @on.cursorStyleChanged.dispatch @getName()

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
