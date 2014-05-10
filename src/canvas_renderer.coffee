`import TwoObject from "object"`
`import Property from "./property"`
`import DeviceMetrics from "./device_metrics"`
`import Matrix2d from "./matrix2d"`

CanvasRenderer = TwoObject.extend
  transform: new Matrix2d()

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

  drawImage: (options) ->
    @transform.values.set options.transform.values
    @transform.scale @_canvas.devicePixelRatio

    @_context.setTransform.apply @_context, @transform.values
    @_context.drawImage options.image, -options.origin[0], -options.origin[1]

`export default CanvasRenderer`

