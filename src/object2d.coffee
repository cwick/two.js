define ["gl-matrix", "./material", "./utils", "./bounding_box"], \
       (gl, Material, Utils, BoundingBox) ->
  class Object2d
    @_nextId = 1

    constructor: (options={}) ->
      @material = options.material ?= new Material()
      @_x = options.x ?= 0
      @_y = options.y ?= 0
      @pixelOffsetX = options.pixelOffsetX ?= 0
      @pixelOffsetY = options.pixelOffsetY ?= 0
      @_origin = options.origin ?= [0,0]
      @_name = options.name ?= ""
      @_scale = options.scale ?= 1
      @_children = []
      @_isVisible = true
      @_isBoundingBoxValid = false
      @_id = Object2d._nextId++

    isVisible: -> @_isVisible
    setVisible: (value) -> @_isVisible = value

    setY: (value) ->
      @_y = value
      @invalidateWorldTransform()
    setX: (value) ->
      @_x = value
      @invalidateWorldTransform()
    getX: -> @_x
    getY: -> @_y

    getPosition: -> gl.vec2.fromValues @_x, @_y
    setPosition: (value) ->
      @_x = value[0]
      @_y = value[1]
      @invalidateWorldTransform()

    getScale: -> @_scale
    setScale: (value) ->
      @_scale = value
      @invalidateWorldTransform()

    getBoundingBox: ->
      unless @_isBoundingBoxValid
        @_recomputeBoundingBox()

      @_boundingBox

    getOrigin: -> @_origin
    setOrigin: (value) ->
      @_origin = value
      @invalidateWorldTransform()

    add: (child) ->
      child._parent = @
      @_children.push child

    remove: (child) ->
      idx = @_children.indexOf child
      if idx != -1
        @_children.splice(idx, 1)
        child._parent = null

    getChildren: -> @_children
    getParent: -> @_parent
    getName: -> @_name
    setName: (value) -> @_name = value

    getId: -> @_id

    getWorldMatrix: ->
      @_updateWorldMatrix() unless @_isWorldMatrixValid
      @_worldMatrix

    cloneProperties: (overrides) ->
      Utils.merge
        x: @_x
        y: @_y
        material: @material
        pixelOffsetX: @pixelOffsetX
        pixelOffsetY: @pixelOffsetY, overrides

    invalidateWorldTransform: ->
      @_isWorldMatrixValid = false
      @invalidateBoundingGeometry()

      child.invalidateWorldTransform() for child in @_children

    invalidateBoundingGeometry: ->
      @_isBoundingBoxValid = false

    _updateWorldMatrix: ->
      unless @_worldMatrix?
        @_worldMatrix = gl.mat2d.create()

      @_worldMatrix[0] = @_scale
      @_worldMatrix[3] = @_scale
      @_worldMatrix[4] = @_x - @_origin[0]
      @_worldMatrix[5] = @_y - @_origin[1]

      if @_parent?
        gl.mat2d.multiply @_worldMatrix, @_parent.getWorldMatrix(), @_worldMatrix

      @_isWorldMatrixValid = true

    _recomputeBoundingBox: ->
      unless @_boundingBox?
        @_boundingBox = new BoundingBox()

      @_shrinkWrapBoundingBox()

      if @_parent?
        @_boundingBox.applyMatrix @_parent.getWorldMatrix()

      @_isBoundingBoxValid = true

    _shrinkWrapBoundingBox: ->
      position = @getPosition()
      origin = @getOrigin()
      scale = @getScale()

      @_boundingBox.setPosition [position[0] - origin[0], position[1] - origin[1]]
      @_boundingBox.setWidth scale*@getBoundingWidth()
      @_boundingBox.setHeight scale*@getBoundingHeight()

