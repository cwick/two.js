define ["gl-matrix"], (gl) ->
  class Camera
    constructor: (options) ->
      options ?= {}
      @_screenWidth = options.screenWidth ?= 500
      @_screenHeight = options.screenHeight ?= 500
      @_aspectRatio = @_screenWidth / @_screenHeight
      @setWidth(options.width ?= 10)
      @x = options.x ?= 0
      @y = options.y ?= 0

    setWidth: (@_width) ->
      @_height = @_width / @_aspectRatio
      @_projectionMatrix = null

    getWidth: -> @_width
    getHeight: -> @_height

    getWorldMatrix: ->
      @_worldMatrix ?= @_createWorldMatrix()

    getProjectionMatrix: ->
      @_projectionMatrix ?= @_createProjectionMatrix()

    _createProjectionMatrix: ->
      m = gl.mat3.create()
      m[0] = @_screenWidth / @_width
      m[2] = @_screenWidth / 2
      m[4] = -m[0]
      m[5] = @_screenHeight / 2
      m

    _createWorldMatrix: ->
      m = gl.mat3.create()
      m[2] = @x
      m[5] = @y
      m
