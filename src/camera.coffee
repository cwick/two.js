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
      @_viewProjectionMatrix = null

    getWidth: -> @_width
    getHeight: -> @_height

    getPosition: -> gl.vec2.fromValues @_x, @_y
    setPosition: (p) ->
      [@_x, @_y] = p
      @_worldMatrix = null
      @_viewMatrix = null
      @_viewProjectionMatrix = null

    getWorldMatrix: ->
      @_worldMatrix ?= @_createWorldMatrix()

    getViewMatrix: ->
      @_viewMatrix ?= @_createViewMatrix()

    getViewProjectionMatrix: ->
      @_viewProjectionMatrix ?= @_createViewProjectionMatrix()

    getProjectionMatrix: ->
      @_projectionMatrix ?= @_createProjectionMatrix()

    getProjectionMatrixInverse: ->
      @_projectionMatrixInverse ?= @_createProjectionMatrixInverse()

    project: (worldPoint) ->
      normalizedScreenPoint = gl.vec2.create()
      viewProjection = @getViewProjectionMatrix()

      gl.vec2.transformMat2d normalizedScreenPoint, worldPoint, viewProjection

    unproject: (normalizedScreenPoint) ->
      worldPoint = gl.vec2.create()

      viewProjectionInverse = gl.mat2d.create()
      gl.mat2d.multiply viewProjectionInverse, @getProjectionMatrixInverse(), @getWorldMatrix()
      gl.vec2.transformMat2d worldPoint, normalizedScreenPoint, viewProjectionInverse

    pick: (normalizedScreenPoint, scene) ->
      worldPoint = @unproject normalizedScreenPoint

      for object in scene.getChildren() by -1
        if !object.material.isFixedSize && object.getBoundingBox().containsPoint(worldPoint)
          return object

        picked = @pick normalizedScreenPoint, object
        return picked if picked?

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

    _createViewMatrix: ->
      view = gl.mat2d.create()
      world = @getWorldMatrix()

      gl.mat2d.invert view, world

    _createViewProjectionMatrix: ->
      viewProjection = gl.mat2d.create()
      view = @getViewMatrix()
      projection = @getProjectionMatrix()

      gl.mat2d.multiply viewProjection, view, projection
      viewProjection

