define ["./material", "./color"], (Material, Color) ->
  class ShapeMaterial extends Material
    constructor: (options={}) ->
      @fillColor = @_makeColor(options.fillColor)
      @strokeColor = @_makeColor(options.strokeColor, new Color(a: 0))

      super options


