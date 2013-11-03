define ["./material", "./utils"], (Material, Utils) ->
  class Object2d
    constructor: (options={}) ->
      @material = options.material ?= new Material()
      @x = options.x ?= 0
      @y = options.y ?= 0
      @pixelOffsetX = options.pixelOffsetX ?= 0
      @pixelOffsetY = options.pixelOffsetY ?= 0
      @_name = options.name ?= ""
      @_children = []

    getBoundingBox: ->
      @_boundingBox ?= @_createBoundingBox()

    getBoundingDisc: ->
      @_boundingDisc ?= @_createBoundingDisc()

    add: (object) ->
      @_children.push object

    getChildren: -> @_children
    getName: -> @_name

    cloneProperties: (overrides) ->
      Utils.merge
        x: @x
        y: @y
        material: @material
        pixelOffsetX: @pixelOffsetX
        pixelOffsetY: @pixelOffsetY, overrides

