`import TwoObject from "object"`
`import Property from "./property"`

CanvasRenderer = TwoObject.extend
  canvas: Property
    set: (value) ->
      @_canvas = value
      @_context = @_canvas.getContext "2d"

  execute: (command) ->
    @["#{command.name}Command"](command)

  clearCommand: (options) ->
    @_context.setTransform(1, 0, 0, 1, 0, 0)
    @_context.fillStyle = options.color.toCSS()
    @_context.fillRect 0,0, @_canvas.frameWidth, @_canvas.frameHeight

`export default CanvasRenderer`

