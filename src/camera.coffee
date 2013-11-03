define ["gl-matrix"], (gl) ->
  class Camera
    constructor: (options) ->
      options ?= {}
      @_aspectRatio = options.aspectRatio ?= 1
      @setWidth(options.width ?= 10)
      @_x = options.x ?= 0
      @_y = options.y ?= 0

    setWidth: (@_width) ->
      @_height = @_width / @_aspectRatio
      @_projectionMatrix = null
      @_projectionMatrixInverse = null

    getWidth: -> @_width
    getHeight: -> @_height

    getPosition: -> gl.vec2.fromValues @_x, @_y
    setPosition: (p) ->
      [@_x, @_y] = p
      @_worldMatrix = null

    getWorldMatrix: ->
      @_worldMatrix ?= @_createWorldMatrix()

    getProjectionMatrix: ->
      @_projectionMatrix ?= @_createProjectionMatrix()

    getProjectionMatrixInverse: ->
      @_projectionMatrixInverse ?= @_createProjectionMatrixInverse()

    unproject: (normalizedScreenPoint) ->
      worldPoint = gl.vec2.create()

      viewProjectionInverse = gl.mat2d.create()
      gl.mat2d.multiply viewProjectionInverse, @getProjectionMatrixInverse(), @getWorldMatrix()
      gl.vec2.transformMat2d worldPoint, normalizedScreenPoint, viewProjectionInverse

    pick: (normalizedScreenPoint, scene) ->
      worldPoint = @unproject normalizedScreenPoint

      for object in scene.getChildren()
        if object.getBoundingDisc().intersectsWith worldPoint
          if object.getBoundingBox().intersectsWith worldPoint
            return object

        # picked = @pick screenPoint, object, renderer
        # return picked if picked?

      return null

    _createProjectionMatrix: ->
      m = gl.mat2d.create()
      m[0] = 2 / @_width
      m[3] = 2 / @_height
      m

    _createProjectionMatrixInverse: ->
      projection = gl.mat2d.clone(@getProjectionMatrix())
      gl.mat2d.invert projection, projection
      projection

    _createWorldMatrix: ->
      m = gl.mat2d.create()
      m[4] = @_x
      m[5] = @_y
      m
