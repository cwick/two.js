define ["jquery"], ($) ->
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
      screenWidth = @getWidth()
      screenHeight = @getHeight()

      cameraWidth = camera.getWidth()
      cameraHeight = camera.getHeight()

      @_context.setTransform(1, 0, 0, 1, 0, 0)
      @_context.clearRect 0,0, screenWidth, screenHeight

      @_context.setTransform(
        screenWidth/cameraWidth,
        0,
        0,
        -screenHeight/cameraHeight,
        screenWidth/2 - ((camera.x*screenWidth)/cameraWidth),
        screenHeight/2 + ((camera.y*screenHeight)/cameraHeight))

      for object in scene.objects
        @_context.fillStyle = object.color
        @_context.beginPath()
        @_context.arc object.x, object.y, object.radius, 0, 2*Math.PI
        @_context.closePath()
        @_context.fill()

