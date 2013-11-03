define ["./material", "./utils"], (Material, Utils) ->
  class Object2d
    constructor: (options={}) ->
      @material = options.material ?= new Material()
      @x = options.x ?= 0
      @y = options.y ?= 0
      @screenOffsetX = options.screenOffsetX ?= 0
      @screenOffsetY = options.screenOffsetY ?= 0
      @_children = []

    getBoundingBox: ->
      @_boundingBox ?= @_createBoundingBox()

    getBoundingDisc: ->
      @_boundingDisc ?= @_createBoundingDisc()

    add: (object) ->
      @_children.push object

    getChildren: -> @_children

    cloneProperties: (overrides) ->
      Utils.merge
        x: @x
        y: @y
        material: @material
        screenOffsetX: @screenOffsetX
        screenOffsetY: @screenOffsetY, overrides

