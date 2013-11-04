define ["jquery", "gl-matrix", "./box", "./disc"], ($, gl, Box, Disc) ->
  class CanvasRenderer
    constructor: (options) ->
      @$domElement = $("<canvas/>")
      @domElement = @$domElement.get(0)

      @_devicePixelRatio = window.devicePixelRatio
      @$domElement.attr
        width: options.width*@_devicePixelRatio
        height: options.height*@_devicePixelRatio
      @_context = @domElement.getContext "2d"
      @autoClear = options.autoClear ?= true

      @_width = options.width
      @_height = options.height

    getAspectRatio: -> @domElement.width / @domElement.height
    getWidth: -> @_width
    getHeight: -> @_height

    getDevicePixelRatio: -> @_devicePixelRatio

    render: (scene, camera) ->
      @_prepareToRender(camera)

      for object in scene.getChildren()
        @_renderObject(object)
        @_renderObject(child) for child in object.getChildren()

      # Don't collect results into an array
      return

    _renderObject: (object) ->
      @_context.save()

      if object.pixelOffsetX != 0 || object.pixelOffsetY != 0
        @_context.translate object.pixelOffsetX*@_devicePixelRatio, object.pixelOffsetY*@_devicePixelRatio

      viewProjection = @_applyViewProjectionMatrix()

      # Don't scale line width with projection matrix
      @_context.lineWidth = 1/viewProjection[0]

      material = object.material
      @_context.fillStyle = material.fillColor?.css()
      @_context.strokeStyle = material.strokeColor?.css()

      if material.isFixedSize
        @_context.translate object.x, object.y
        @_context.scale @_devicePixelRatio/viewProjection[0], @_devicePixelRatio/viewProjection[0]
        @_context.translate -object.x, -object.y
        @_context.lineWidth = 1

      @_context.beginPath()

      if object instanceof Disc
        @_context.arc object.x, object.y, object.radius, 0, 2*Math.PI
      else if object instanceof Box
        @_context.rect object.x-object.width/2, object.y-object.height/2, object.width, object.height

      @_context.closePath()

      if material.fillColor?
        @_context.fill()
      if material.strokeColor?
        @_context.stroke()

      @_context.restore()

    clear: ->
      @_context.setTransform(1, 0, 0, 1, 0, 0)
      @_context.clearRect 0,0, @domElement.width, @domElement.height

    _prepareToRender: (camera) ->
      @_camera = camera
      @_viewProjectionMatrix = null
      @_context.setTransform(1, 0, 0, 1, 0, 0)
      # Avoid blurry lines
      @_context.translate 0.5, 0.5
      @clear() if @autoClear

    _getViewProjectionMatrix: ->
      @_viewProjectionMatrix ?= @_createViewProjectionMatrix()

    _createViewProjectionMatrix: ->
      viewProjection = @_camera.getViewProjectionMatrix()

      # Map from normalized device coordinates to physical screen pixel coordinates
      deviceMap = gl.mat2d.create()
      deviceMap[0] =  @domElement.width / 2
      deviceMap[3] = -@domElement.height / 2
      deviceMap[4] =  @domElement.width / 2
      deviceMap[5] =  @domElement.height / 2

      gl.mat2d.multiply deviceMap, viewProjection, deviceMap
      deviceMap

    _applyViewProjectionMatrix: ->
      viewProjection = @_getViewProjectionMatrix()

      @_context.transform(
        viewProjection[0], viewProjection[1]
        viewProjection[2], viewProjection[3]
        viewProjection[4], viewProjection[5])

      viewProjection