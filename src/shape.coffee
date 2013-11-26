define ["./shape_material", "./object2d"], (ShapeMaterial, Object2d) ->
  class Shape extends Object2d
    constructor: (options={}) ->
      options.material ?= new ShapeMaterial()
      unless options.material instanceof ShapeMaterial
        throw new Error("Material must be instance of ShapeMaterial")

      super options
