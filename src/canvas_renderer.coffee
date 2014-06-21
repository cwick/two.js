`import TwoObject from "./object"`
`import Property from "./property"`
`import DeviceMetrics from "./device_metrics"`
`import Matrix2d from "./matrix2d"`
`import Canvas from "./canvas"`

CanvasRenderer = TwoObject.extend
  initialize: ->
    @canvas = new Canvas()

  canvas: Property
    set: (value) ->
      @_canvas = value
      @_context = @_canvas.getContext "2d"

  imageSmoothingEnabled: Property
    set: (value) ->
      @_imageSmoothingEnabled =
        @_context.imageSmoothingEnabled =
        @_context.mozImageSmoothingEnabled =
        @_context.webkitImageSmoothingEnabled = value

  execute: (command) ->
    @[command.name](command)

  clear: (options) ->
    @_context.setTransform(1, 0, 0, 1, 0, 0)
    @_context.fillStyle = options.color.toCSS()
    @_context.fillRect 0,0, @_canvas.frameWidth, @_canvas.frameHeight

  setTransform: (transform) ->
    values = transform.values
    devicePixelRatio = @_canvas._devicePixelRatio

    # Upscale according to devicePixelRatio and flip the Y axis
    @_context.setTransform(
      devicePixelRatio * values[0],
      -devicePixelRatio * values[1],
      -devicePixelRatio * values[2],
      devicePixelRatio * values[3],
      devicePixelRatio * values[4],
      devicePixelRatio * (@_canvas._height - values[5]))

  drawImage: (options) ->
    image = options.image
    crop = options.crop
    origin = options.origin

    @setTransform options.transform

    # Need to shift source rect by 0.5 pixels to prevent pixel bleeding
    @_context.drawImage(
      image,
      crop.x + .5, #source X
      crop.y + .5, #source Y
      crop.width - .5,  #source width
      crop.height - .5, #source height
      -origin[0], #destination X
      -origin[1], #destination Y
      image.width, #destination width
      image.height) #destination height

`export default CanvasRenderer`

