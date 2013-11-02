define ["gl-matrix"], (gl) ->
  class Camera
    constructor: (options) ->
      options ?= {}
      @_screenWidth = options.screenWidth ?= 500
      @_screenHeight = options.screenHeight ?= 500
      @_aspectRatio = @_screenWidth / @_screenHeight
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
      [@x, @y] = p
      @_worldMatrix = null

    getWorldMatrix: ->
      @_worldMatrix ?= @_createWorldMatrix()

    getProjectionMatrix: ->
      @_projectionMatrix ?= @_createProjectionMatrix()

    getProjectionMatrixInverse: ->
      @_projectionMatrixInverse ?= @_createProjectionMatrixInverse()

    unproject: (out, screenPoint) ->
      viewProjectionInverse = gl.mat3.create()
      gl.mat3.multiply viewProjectionInverse, @getWorldMatrix(), @getProjectionMatrixInverse()
      gl.vec2.transformMat3 out, screenPoint, viewProjectionInverse
      out

    _createProjectionMatrix: ->
      m = gl.mat3.create()
      m[0] = @_screenWidth / @_width
      m[4] = -m[0]
      m[6] = @_screenWidth / 2
      m[7] = @_screenHeight / 2
      m

    _createProjectionMatrixInverse: ->
      projection = gl.mat3.clone(@getProjectionMatrix())
      gl.mat3.invert projection, projection
      projection

    _createWorldMatrix: ->
      m = gl.mat3.create()
      m[6] = @_x
      m[7] = @_y
      m
