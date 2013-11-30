define ["./shape_material", "./color", "./utils"], (ShapeMaterial, Color, Utils) ->
  class SpriteMaterial extends ShapeMaterial
    constructor: (options={}) ->
      options.fillColor ?= new Color(a: 0)
      options.strokeColor ?= new Color(a: 0)
      options.offsetX ?= 0
      options.offsetY ?= 0
      options.width ?= 0
      options.height ?= 0

      @image = options.image
      @width = options.width
      @height = options.height
      @offsetX = options.offsetX
      @offsetY = options.offsetY

      delete options.image
      delete options.offsetX
      delete options.offsetY
      delete options.width
      delete options.height

      super

    clone: (overrides) ->
      new SpriteMaterial(@cloneProperties overrides)

    cloneProperties: (overrides) ->
      super Utils.merge(
        offsetX: @offsetX
        offsetY: @offsetY
        width: @width
        height: @height,
        image: @image, overrides)
