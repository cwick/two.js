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
      [@_x, @_y] = p
      @_worldMatrix = null

    getWorldMatrix: ->
      @_worldMatrix ?= @_createWorldMatrix()

    getProjectionMatrix: ->
      @_projectionMatrix ?= @_createProjectionMatrix()

    getProjectionMatrixInverse: ->
      @_projectionMatrixInverse ?= @_createProjectionMatrixInverse()

    unproject: (out, screenPoint) ->
      viewProjectionInverse = gl.mat2d.create()
      gl.mat2d.multiply viewProjectionInverse, @getProjectionMatrixInverse(), @getWorldMatrix()
      gl.vec2.transformMat2d out, screenPoint, viewProjectionInverse
      out

    pick: (screenPoint, scene) ->
      worldPoint = screenPoint
      @unproject worldPoint, screenPoint

      for object in scene.objects
        if object.getBoundingDisc().intersectsWith worldPoint
          return object

      return null

    _createProjectionMatrix: ->
      m = gl.mat2d.create()
      m[0] = @_screenWidth / @_width
      m[3] = -m[0]
      m[4] = @_screenWidth / 2
      m[5] = @_screenHeight / 2
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
