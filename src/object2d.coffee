define ["gl-matrix", "./material", "./utils"], (gl, Material, Utils) ->
  class Object2d
    constructor: (options={}) ->
      @material = options.material ?= new Material()
      @_x = options.x ?= 0
      @_y = options.y ?= 0
      @pixelOffsetX = options.pixelOffsetX ?= 0
      @pixelOffsetY = options.pixelOffsetY ?= 0
      @_name = options.name ?= ""
      @_children = []

    setY: (value) ->
      @_y = value
      @_invalidateBoundingGeometry()
    setX: (value) ->
      @_x = value
      @_invalidateBoundingGeometry()

    getPosition: -> gl.vec2.fromValues @_x, @_y
    setPosition: (value) ->
      @_x = value[0]
      @_y = value[1]
      @_invalidateBoundingGeometry()

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
        x: @_x
        y: @_y
        material: @material
        pixelOffsetX: @pixelOffsetX
        pixelOffsetY: @pixelOffsetY, overrides

    _invalidateBoundingGeometry: ->
      @_boundingBox = @_boundingDisc = null
