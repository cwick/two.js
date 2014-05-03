`import TwoObject from "object"`
`import Property from "./property"`

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
    @_context.setTransform.apply @_context, options.transform
    @_context.drawImage options.image, 0, 0

`export default CanvasRenderer`

