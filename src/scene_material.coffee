define ["./material", "./color", "./utils"], (Material, Color, Utils) ->
  class SceneMaterial extends Material
    constructor: (options={}) ->
      @backgroundColor = @_makeColor(options.backgroundColor, new Color(a: 0))

      super options

    clone: (overrides) ->
      new SceneMaterial(@cloneProperties overrides)

    cloneProperties: (overrides) ->
      super Utils.merge(
        backgroundColor: @backgroundColor)

