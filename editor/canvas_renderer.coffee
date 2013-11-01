define ["jquery"], ($) ->
  class CanvasRenderer
    constructor: (options) ->
      @$domElement = $("<canvas/>")
      @domElement = @$domElement.get(0)

      @$domElement.attr width: options.width, height: options.height
      @_context = @domElement.getContext "2d"

    getAspectRatio: -> @$domElement.attr("width") / @$domElement.attr("height")
    getWidth: -> @$domElement.attr("width")
    getHeight: -> @$domElement.attr("height")

    render: (scene, camera) ->
      screenWidth = @getWidth()
      screenHeight = @getHeight()

      @_context.setTransform(
        screenWidth/camera.width,
        0,
        0,
        -screenHeight/camera.height,
        screenWidth/2 - ((camera.x*screenWidth)/camera.width),
        screenHeight/2 + ((camera.y*screenHeight)/camera.height))

      for object in scene.objects
        console.log object
        console.log camera
        @_context.fillStyle = object.color
        @_context.beginPath()
        @_context.arc object.x, object.y, object.radius, 0, 2*Math.PI
        @_context.closePath()
        @_context.fill()

