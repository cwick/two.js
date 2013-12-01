define ["jquery",
        "gl-matrix",
        "./box",
        "./disc",
        "./sprite",
        "./line_group",
        "./shape",
        "./scene",
        "./shape_material",
        "./line_material",
        "./scene_material"], \
       ($, gl, Box, Disc, Sprite, LineGroup, Shape, Scene, ShapeMaterial, LineMaterial, SceneMaterial) ->
  class CanvasRenderer
    constructor: (options) ->
      @$domElement = $("<canvas/>", tabindex: 0)
      @domElement = @$domElement.get(0)

      @resize options.width, options.height
      @autoClear = options.autoClear ?= true

    getAspectRatio: -> @domElement.width / @domElement.height
    getWidth: -> @_width
    getHeight: -> @_height

    resize: (width, height) ->
      @_devicePixelRatio = window.devicePixelRatio
      @_width = width
      @_height = height

      @$domElement.attr
        width: width*@_devicePixelRatio
        height: height*@_devicePixelRatio

      @_context = @domElement.getContext "2d"
      @_disableImageSmoothing()

    getDevicePixelRatio: -> @_devicePixelRatio

    render: (scene, camera) ->
      @_prepareToRender(camera)
      @_renderTree scene

    _renderTree: (root) ->
      @_renderObject root
      @_renderTree(c) for c in root.getChildren()

      # Don't collect results into an array
      return

    _renderObject: (object) ->
      return unless object.isVisible()
      @_context.save()

      # Avoid blurry lines
      @_context.translate 0.5, 0.5 if object instanceof LineGroup

      if object.getPixelOffsetX() != 0 || object.getPixelOffsetY() != 0
        @_context.translate(
          object.getPixelOffsetX()*@_devicePixelRatio,
          object.getPixelOffsetY()*@_devicePixelRatio)

      viewProjection = @_applyMatrix(@_getViewProjectionMatrix())

      # Don't scale line width with object or view scale
      @_context.lineWidth = 1/(viewProjection[0] * object.getScale())

      material = object.getMaterial()

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

      if material?.isFixedSize
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
        for v in object.getVertices()
          if begin
            @_context.moveTo v[0], v[1]
          else
            @_context.lineTo v[0], v[1]
          begin = !begin

        @_context.stroke()
      else if object instanceof Scene
        "adsf"
      else
        throw new Error("Unknown object type #{object.constructor.name}")

      if object instanceof Sprite
        @_drawSprite object

      if object instanceof Shape
        @_context.fill() unless object.getMaterial().fillColor.a is 0
        @_context.stroke() unless object.getMaterial().strokeColor.a is 0

      @_context.closePath()

    _applyObjectMaterial: (material) ->
      return unless material?
      @_context.globalAlpha = material.opacity
      if material instanceof ShapeMaterial
        @_context.fillStyle = material.fillColor.toCSS()
        @_context.strokeStyle = material.strokeColor.toCSS()
      else if material instanceof LineMaterial
        @_context.strokeStyle = material.color.toCSS()
      else if material instanceof SceneMaterial
        "sadf"
      else
        throw new Error("Unknown material type #{material.constructor.name}")

    _disableImageSmoothing: ->
      @_context.imageSmoothingEnabled = false
      @_context.mozImageSmoothingEnabled = false
      @_context.webkitImageSmoothingEnabled = false

    _drawSprite: (sprite) ->
      material = sprite.getMaterial()
      image = material.image

      return unless image

      imageData = image.getImageData()

      sourceWidth = material.width || image.getWidth()
      sourceHeight = material.height || image.getHeight()
      sourceX = material.offsetX
      sourceY = image.getHeight() - material.offsetY - sourceHeight

      destinationX = -sprite.getWidth()/2
      destinationY = -sprite.getHeight()/2
      destinationWidth = sprite.getWidth()
      destinationHeight = sprite.getHeight()

      @_context.scale 1, -1
      @_context.drawImage(
        image.getImageData(),
        sourceX
        sourceY,
        sourceWidth,
        sourceHeight,
        destinationX,
        destinationY,
        destinationWidth,
        destinationHeight)
