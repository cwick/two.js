define ["two/box", "two/material", "two/color"], (Box, Material, Color) ->
  SELECTION_COLOR = new Color(r: 20, g: 0, b: 229)
  SELECTION_FILL_COLOR = SELECTION_COLOR.clone(a: 0.1)

  class SelectionBox extends Box
    constructor: (options={}) ->
      options.material ?= new Material(strokeColor: SELECTION_COLOR, fillColor: SELECTION_FILL_COLOR)
      super options

      @_resizeHandle = new Box
        y: 0
        width: 5
        height: 5
        material: new Material(strokeColor: SELECTION_COLOR, fillColor: "white")

      @add @_resizeHandle

    attachTo: (object) ->
      bounds = object.getBoundingBox()
      @x = object.x
      @y = object.y
      @width = bounds.width
      @height = bounds.height
      @_resizeHandle.x = bounds.width/2
