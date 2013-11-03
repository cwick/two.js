define ["./material"], (Material) ->
  class Object2d
    constructor: (options={}) ->
      @material = options.material ?= new Material()
      @x = options.x ?= 0
      @y = options.y ?= 0

    getBoundingBox: ->
      @_boundingBox ?= @_createBoundingBox()

    getBoundingDisc: ->
      @_boundingDisc ?= @_createBoundingDisc()
