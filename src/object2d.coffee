define ["./material"], (Material) ->
  class Object2d
    constructor: (options={}) ->
      @material = options.material ?= new Material()
      @x = options.x ?= 0
      @y = options.y ?= 0
      @_children = []

    getBoundingBox: ->
      @_boundingBox ?= @_createBoundingBox()

    getBoundingDisc: ->
      @_boundingDisc ?= @_createBoundingDisc()

    add: (object) ->
      @_children.push object

    getChildren: -> @_children

    cloneProperties: ->
      material: @material
      x: @x
      y: @y
