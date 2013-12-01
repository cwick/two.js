define (require) ->
  gl = require "gl-matrix"
  uuid = require "uuid"
  Material = require "./material"
  Utils = require "./utils"
  BoundingBox = require "./bounding_box"

  class Object2d
    constructor: (options={}) ->
      @_parent = null
      @_material = options.material ?= null
      @_x = options.x ?= 0
      @_y = options.y ?= 0
      @_pixelOffsetX = options.pixelOffsetX ?= 0
      @_pixelOffsetY = options.pixelOffsetY ?= 0
      @_origin = options.origin ?= [0,0]
      @_name = options.name ?= ""
      @_scale = options.scale ?= 1
      @_children = []
      @_isVisible = true
      @_isBoundingBoxValid = false
      @_id = options.id ?= uuid.v4()

      options.parent?.add @

      unless options.name
        @setName "Object (#{@getId()})"

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

    getBoundingWidth: -> 0
    getBoundingHeight: -> 0

    getPixelOffsetX: -> @_pixelOffsetX
    getPixelOffsetY: -> @_pixelOffsetY

    getOrigin: -> @_origin
    setOrigin: (value) ->
      @_origin = value
      @invalidateWorldTransform()

    getMaterial: -> @_material
    setMaterial: (value) -> @_material = value

    getChildren: -> @_children
    getParent: -> @_parent
    getName: -> @_name
    setName: (value) -> @_name = value

    getId: -> @_id

    getWorldMatrix: ->
      @_updateWorldMatrix() unless @_isWorldMatrixValid
      @_worldMatrix

    add: (child) ->
      child.getParent()?.remove child
      child._parent = @
      @_children.push child
      child.invalidateWorldTransform()
      child

    remove: (child) ->
      idx = @_children.indexOf child
      if idx != -1
        @_children.splice(idx, 1)
        child._parent = null

    clone: (overrides) ->
      new Object2d(@cloneProperties overrides)

    cloneProperties: (overrides) ->
      Utils.merge
        parent: @_parent
        name: @_name
        x: @_x
        y: @_y
        material: @_material
        origin: @_origin
        scale: @_scale
        pixelOffsetX: @_pixelOffsetX
        pixelOffsetY: @_pixelOffsetY, overrides

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

