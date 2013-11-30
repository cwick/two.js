define ["./material", "./color", "./utils"], (Material, Color, Utils) ->
  class ShapeMaterial extends Material
    constructor: (options={}) ->
      @fillColor = @_makeColor(options.fillColor)
      @strokeColor = @_makeColor(options.strokeColor, new Color(a: 0))

      super options

    clone: (overrides) ->
      new ShapeMaterial(@cloneProperties overrides)

    cloneProperties: (overrides) ->
      super Utils.merge(
        fillColor: @fillColor
        strokeColor: @strokeColor, overrides)

