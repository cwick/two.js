define ["jquery", "gl-matrix"], ($, gl) ->
  class CanvasRenderer
    constructor: (options) ->
      @$domElement = $("<canvas/>")
      @domElement = @$domElement.get(0)

      @$domElement.attr width: options.width, height: options.height
      @_context = @domElement.getContext "2d"

    getAspectRatio: -> @domElement.width / @domElement.height
    getWidth: -> @domElement.width
    getHeight: -> @domElement.height

    render: (scene, camera) ->
      @_prepareToRender(camera)
      viewProjection = @_getViewProjectionMatrix()

      @_context.setTransform(
        viewProjection[0], viewProjection[1]
        viewProjection[2], viewProjection[3]
        viewProjection[4], viewProjection[5])

      for object in scene.objects
        @_context.fillStyle = object.color
        @_context.beginPath()
        @_context.arc object.x, object.y, object.radius, 0, 2*Math.PI
        @_context.closePath()
        @_context.fill()

    _prepareToRender: (camera) ->
      @_camera = camera
      @_viewProjectionMatrix = null
      @_context.setTransform(1, 0, 0, 1, 0, 0)
      @_clearScreen()

    _clearScreen: ->
      @_context.clearRect 0,0, @getWidth(), @getHeight()

    _getViewProjectionMatrix: ->
      @_viewProjectionMatrix ?= @_createViewProjectionMatrix()

    _createViewProjectionMatrix: ->
      view = gl.mat2d.create()
      gl.mat2d.invert view, @_camera.getWorldMatrix()

      viewProjection = gl.mat2d.create()
      gl.mat2d.multiply viewProjection, view, @_camera.getProjectionMatrix()
      viewProjection
