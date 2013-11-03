define ["two/box", "two/material", "two/color"], (Box, Material, Color) ->
  SELECTION_COLOR = new Color(r: 20, g: 0, b: 229)
  SELECTION_FILL_COLOR = SELECTION_COLOR.clone(a: 0.1)
  LARGE_HANDLE_SIZE = 10
  SMALL_HANDLE_SIZE = 5
  HANDLE_PADDING = 0.5

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

      # smallHandle = largeHandle.clone()
      # smallHandle.width = smallHandle.height = SMALL_HANDLE_SIZE

      @add(@_NEResizeHandle = largeHandle.clone())
      @add(@_NWResizeHandle = largeHandle.clone())
      @add(@_SEResizeHandle = largeHandle.clone())
      @add(@_SWResizeHandle = largeHandle.clone())

    attachTo: (object) ->
      bounds = object.getBoundingBox()
      @x = object.x
      @y = object.y
      @width = bounds.width
      @height = bounds.height

      @_NEResizeHandle.x = bounds.width/2 + HANDLE_PADDING
      @_NEResizeHandle.y = bounds.height/2 + HANDLE_PADDING

      @_NWResizeHandle.x = -bounds.width/2 - HANDLE_PADDING
      @_NWResizeHandle.y = bounds.height/2 + HANDLE_PADDING

      @_SEResizeHandle.x = bounds.width/2 + HANDLE_PADDING
      @_SEResizeHandle.y = -bounds.height/2 - HANDLE_PADDING

      @_SWResizeHandle.x = -bounds.width/2 - HANDLE_PADDING
      @_SWResizeHandle.y = -bounds.height/2 - HANDLE_PADDING
