define ["two/box", "two/material", "two/color"], (Box, Material, Color) ->
  SELECTION_COLOR = new Color(r: 20, g: 0, b: 229)
  SELECTION_FILL_COLOR = SELECTION_COLOR.clone(a: 0.1)
  LARGE_HANDLE_SIZE = 12
  LARGE_HANDLE_PADDING = 14
  SMALL_HANDLE_SIZE = LARGE_HANDLE_SIZE / 2 + 2
  SMALL_HANDLE_PADDING = LARGE_HANDLE_PADDING + SMALL_HANDLE_SIZE/2

  class SelectionBox extends Box
    constructor: (options={}) ->
      options.material ?= new Material(strokeColor: SELECTION_COLOR, fillColor: SELECTION_FILL_COLOR)
      super options

      handleMaterial =
        new Material
          strokeColor: SELECTION_COLOR
          fillColor: "white"
          isFixedSize: true

      largeHandle = new Box
        width: LARGE_HANDLE_SIZE
        height: LARGE_HANDLE_SIZE
        material: handleMaterial

      smallHandle = largeHandle.clone()
      smallHandle.width = smallHandle.height = SMALL_HANDLE_SIZE

      @add(@_NEResizeHandle = largeHandle.clone(
        pixelOffsetX: LARGE_HANDLE_PADDING
        pixelOffsetY: -LARGE_HANDLE_PADDING))

      @add(@_NWResizeHandle = largeHandle.clone(
        pixelOffsetX: -LARGE_HANDLE_PADDING
        pixelOffsetY: -LARGE_HANDLE_PADDING))

      @add(@_SEResizeHandle = largeHandle.clone(
        pixelOffsetX: LARGE_HANDLE_PADDING
        pixelOffsetY: LARGE_HANDLE_PADDING))

      @add(@_SWResizeHandle = largeHandle.clone(
        pixelOffsetX: -LARGE_HANDLE_PADDING
        pixelOffsetY: LARGE_HANDLE_PADDING))

      @add(@_NResizeHandle = smallHandle.clone(
        pixelOffsetY: -SMALL_HANDLE_PADDING))

      @add(@_EResizeHandle = smallHandle.clone(
        pixelOffsetX: SMALL_HANDLE_PADDING))

      @add(@_SResizeHandle = smallHandle.clone(
        pixelOffsetY: SMALL_HANDLE_PADDING))

      @add(@_WResizeHandle = smallHandle.clone(
        pixelOffsetX: -SMALL_HANDLE_PADDING))

    attachTo: (object) ->
      bounds = object.getBoundingBox()
      @x = object.x
      @y = object.y
      @width = bounds.width
      @height = bounds.height

      @_NEResizeHandle.x = bounds.width/2
      @_NEResizeHandle.y = bounds.height/2

      @_NWResizeHandle.x = -bounds.width/2
      @_NWResizeHandle.y = bounds.height/2

      @_SEResizeHandle.x = bounds.width/2
      @_SEResizeHandle.y = -bounds.height/2

      @_SWResizeHandle.x = -bounds.width/2
      @_SWResizeHandle.y = -bounds.height/2

      @_NResizeHandle.y = bounds.height/2
      @_EResizeHandle.x = bounds.width/2
      @_SResizeHandle.y = -bounds.height/2
      @_WResizeHandle.x = -bounds.width/2
