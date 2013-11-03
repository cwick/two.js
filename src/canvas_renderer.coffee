define ["jquery", "gl-matrix", "./box", "./disc"], ($, gl, Box, Disc) ->
  class CanvasRenderer
    constructor: (options) ->
      @$domElement = $("<canvas/>")
      @domElement = @$domElement.get(0)

      @$domElement.attr width: options.width, height: options.height
      @_context = @domElement.getContext "2d"
      @autoClear = options.autoClear ?= true

    getAspectRatio: -> @domElement.width / @domElement.height
    getWidth: -> @domElement.width
    getHeight: -> @domElement.height

    render: (scene, camera) ->
      @_prepareToRender(camera)
      viewProjection = @_getViewProjectionMatrix()

      # Avoid blurry lines
      @_context.translate(0.5, 0.5)
      @_context.transform(
        viewProjection[0], viewProjection[1]
        viewProjection[2], viewProjection[3]
        viewProjection[4], viewProjection[5])

      # Don't scale line width with projection matrix
      @_context.lineWidth = 1/viewProjection[0]

      for object in scene.objects
        @_renderObject(object)
        @_renderObject(child) for child in object.getChildren()

      # Don't collect results into an array
      return

    _renderObject: (object) ->
      material = object.material
      @_context.fillStyle = material.fillColor?.css()
      @_context.strokeStyle = material.strokeColor?.css()

      @_context.beginPath()

      if object instanceof Disc
        @_context.arc object.x, object.y, object.radius, 0, 2*Math.PI
      else if object instanceof Box
        @_context.rect object.x-object.width/2, object.y-object.height/2, object.width, object.height

      @_context.closePath()

      if material.strokeColor?
        @_context.stroke()
      if material.fillColor?
        @_context.fill()

    clear: ->
      @_context.setTransform(1, 0, 0, 1, 0, 0)
      @_context.clearRect 0,0, @getWidth(), @getHeight()

    _prepareToRender: (camera) ->
      @_camera = camera
      @_viewProjectionMatrix = null
      @_context.setTransform(1, 0, 0, 1, 0, 0)
      @clear() if @autoClear

    _getViewProjectionMatrix: ->
      @_viewProjectionMatrix ?= @_createViewProjectionMatrix()

    _createViewProjectionMatrix: ->
      view = gl.mat2d.create()
      gl.mat2d.invert view, @_camera.getWorldMatrix()

      viewProjection = gl.mat2d.create()
      gl.mat2d.multiply viewProjection, view, @_camera.getProjectionMatrix()
      viewProjection
