define ["gl-matrix", "./material", "./utils", "./bounding_box", "./bounding_disc"], \
       (gl, Material, Utils, BoundingBox, BoundingDisc) ->
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
      @_invalidateWorldTransform
    setX: (value) ->
      @_x = value
      @_invalidateWorldTransform()

    getPosition: -> gl.vec2.fromValues @_x, @_y
    setPosition: (value) ->
      @_x = value[0]
      @_y = value[1]
      @_invalidateWorldTransform()

    getBoundingBox: ->
      unless @_isBoundingBoxValid
        @_recomputeBoundingBox()

      @_boundingBox

    getBoundingDisc: ->
      unless @_isBoundingDiscValid
        @_recomputeBoundingDisc()

      @_boundingDisc


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

    # Override this in derived classes
    updateBoundingBox: ->

    # Override this in derived classes
    updateBoundingDisc: ->

    _updateWorldMatrix: ->
      unless @_worldMatrix?
        @_worldMatrix = gl.mat2d.create()
      @_worldMatrix[4] = @_x
      @_worldMatrix[5] = @_y

      if @_parent?
        gl.mat2d.multiply @_worldMatrix, @_parent.getWorldMatrix(), @_worldMatrix

      @_isWorldMatrixValid = true

    _invalidateWorldTransform: ->
      @_isWorldMatrixValid = false
      @_invalidateBoundingGeometry()

      child._invalidateWorldTransform() for child in @_children

    _invalidateBoundingGeometry: ->
      @_isBoundingBoxValid = @_isBoundingDiscValid = false

    _recomputeBoundingBox: ->
      unless @_boundingBox?
        @_boundingBox = new BoundingBox()

      @updateBoundingBox @_boundingBox

      if @_parent?
        @_boundingBox.applyMatrix @_parent.getWorldMatrix()

      @_isBoundingBoxValid = true

    _recomputeBoundingDisc: ->
      unless @_boundingDisc?
        @_boundingDisc = new BoundingDisc()

      @updateBoundingDisc @_boundingDisc

      if @_parent?
        @_boundingDisc.applyMatrix @_parent.getWorldMatrix()

      @_isBoundingDiscValid = true
