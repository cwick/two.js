define ["jquery",
        "gl-matrix",
        "./box",
        "./disc",
        "./sprite",
        "./line_group",
        "./shape",
        "./shape_material",
        "./line_material"], \
       ($, gl, Box, Disc, Sprite, LineGroup, Shape, ShapeMaterial, LineMaterial) ->
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

      @_disableImageSmoothing()

    getAspectRatio: -> @domElement.width / @domElement.height
    getWidth: -> @_width
    getHeight: -> @_height

    getDevicePixelRatio: -> @_devicePixelRatio

    render: (scene, camera) ->
      @_prepareToRender(camera)

      for object in scene.getChildren()
        continue unless object.isVisible()
        @_renderObject(object)
        @_renderObject(child) for child in object.getChildren()

      # Don't collect results into an array
      return

    _renderObject: (object) ->
      @_context.save()

      if object.pixelOffsetX != 0 || object.pixelOffsetY != 0
        @_context.translate object.pixelOffsetX*@_devicePixelRatio, object.pixelOffsetY*@_devicePixelRatio

      viewProjection = @_applyMatrix(@_getViewProjectionMatrix())

      # Don't scale line width with object or view scale
      @_context.lineWidth = 1/(viewProjection[0] * object.getScale())

      material = object.material

      @_applyWorldTransform object, material, viewProjection[0]
      @_applyObjectMaterial material
      @_drawObjectShape object

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

    _applyMatrix: (m) ->
      @_context.transform(
        m[0], m[1]
        m[2], m[3]
        m[4], m[5])

      return m

    _applyWorldTransform: (object, material, viewScaleFactor) ->
      @_applyMatrix object.getWorldMatrix()

      if material.isFixedSize
        @_context.scale @_devicePixelRatio/viewScaleFactor, @_devicePixelRatio/viewScaleFactor
        @_context.lineWidth = 1

    _drawObjectShape: (object) ->
      @_context.beginPath()

      if object instanceof Disc
        @_context.arc(
          0,
          0,
          object.radius,
          0,
          2*Math.PI)
      else if object instanceof Box
        @_context.rect(
          -object.getWidth()/2,
          -object.getHeight()/2,
          object.getWidth(),
          object.getHeight())
      else if object instanceof LineGroup
        begin = true
        for v in object.vertices
          if begin
            @_context.moveTo v[0], v[1]
          else
            @_context.lineTo v[0], v[1]
          begin = !begin

        @_context.stroke()
      else
        throw new Error("Unknown object type #{object.constructor.name}")

      if object instanceof Sprite
        image = object.material.image
        if image?
          @_context.scale 1, -1
          @_context.drawImage(
            image.getImageData(),
            -object.getWidth()/2,
            -object.getHeight()/2,
            object.getWidth(),
            object.getHeight())

      if object instanceof Shape
        @_context.fill() unless object.material.fillColor.a is 0
        @_context.stroke() unless object.material.strokeColor.a is 0

      @_context.closePath()

    _applyObjectMaterial: (material) ->
      if material instanceof ShapeMaterial
        @_context.fillStyle = material.fillColor.css()
        @_context.strokeStyle = material.strokeColor.css()
      else if material instanceof LineMaterial
        @_context.strokeStyle = material.color.css()
      else
        throw new Error("Unknown material type #{material.constructor.name}")

    _disableImageSmoothing: ->
      @_context.imageSmoothingEnabled = false
      @_context.mozImageSmoothingEnabled = false
      @_context.webkitImageSmoothingEnabled = false
