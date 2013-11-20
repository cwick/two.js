define ["./color"], (Color) ->
  class Material
    constructor: (options) ->
      @isFixedSize = options.isFixedSize ?= false

    _makeColor: (color, _default) ->
      _default = "black" if _default is undefined
      color ?= _default

      if typeof color == "string"
        new Color(color)
      else if color instanceof Color
        color
      else
        throw new Error("Invalid color value #{color}. Must be a string or Color instance")
