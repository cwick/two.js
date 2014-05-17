`import TwoObject from "object"`
`import Property from "./property"`
`import DeviceMetrics from "./device_metrics"`
`import Matrix2d from "./matrix2d"`

CanvasRenderer = TwoObject.extend
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

    @_context.drawImage(
      image,
      crop.x, #source X
      crop.y, #source Y
      crop.width,  #source width
      crop.height, #source height
      -origin[0], #destination X
      -origin[1], #destination Y
      image.width, #destination width
      image.height) #destination height

`export default CanvasRenderer`

