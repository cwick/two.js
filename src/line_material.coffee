define ["./material"], (Material) ->
  class LineMaterial extends Material
    constructor: (options={}) ->
      @color = @_makeColor(options.color)
      @lineWidth = options.lineWidth ?= 1

      super

