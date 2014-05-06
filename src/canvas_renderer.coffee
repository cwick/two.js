`import TwoObject from "object"`
`import Property from "./property"`
`import DeviceMetrics from "./device_metrics"`

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
    @["#{command.name}Command"](command)

  clearCommand: (options) ->
    @_context.setTransform(1, 0, 0, 1, 0, 0)
    @_context.fillStyle = options.color.toCSS()
    @_context.fillRect 0,0, @_canvas.frameWidth, @_canvas.frameHeight

  drawImageCommand: (options) ->
    transform = options.transform.clone()
    transform.scale @_canvas.devicePixelRatio

    @_context.setTransform.apply @_context, transform.values
    @_context.drawImage options.image, 0, 0

`export default CanvasRenderer`

