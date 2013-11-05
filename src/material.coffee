define ["./color"], (Color) ->
  class Material
    constructor: (options={}) ->
      @fillColor = options.fillColor ?= "black"
      @strokeColor = options.strokeColor ?= null

      @fillColor = new Color(@fillColor) if typeof @fillColor == "string"
      @strokeColor = new Color(@strokeColor) if typeof @strokeColor == "string"

      @isFixedSize = options.isFixedSize ?= false
