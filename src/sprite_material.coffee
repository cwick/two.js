define ["./shape_material", "./color"], (ShapeMaterial, Color) ->
  class SpriteMaterial extends ShapeMaterial
    constructor: (options={}) ->
      options.fillColor ?= new Color(a: 0)
      options.strokeColor ?= new Color(a: 0)
      @image = options.image

      delete options.image

      super
