define ->
  class Material
    constructor: (options={}) ->
      @fillColor = options.fillColor ?= "black"
      @strokeColor = options.strokeColor ?= null

