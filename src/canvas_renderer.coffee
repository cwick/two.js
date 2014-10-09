`import TwoObject from "./object"`
`import Property from "./property"`
`import DeviceMetrics from "./device_metrics"`
`import Matrix2d from "./matrix2d"`
`import Canvas from "./canvas"`
`import { Profiler } from "./benchmark"`
`import { iterateThroughNestedArrays } from "./utils"`

CanvasRenderer = TwoObject.extend
  initialize: ->
    @canvas = new Canvas()
    @imageSmoothingEnabled = false
    @flipYAxis = false
    @_referenceFrame = new Matrix2d()

  canvas: Property
    set: (value) ->
      @_canvas = value
      @_context = @_canvas.getContext "2d"

  imageSmoothingEnabled: Property
    set: (value) -> @canvas.imageSmoothingEnabled = value
    get: -> @canvas.imageSmoothingEnabled

  execute: (command) ->
    Profiler.incrementCounter "renderCommands"
    @[command.name](command)

  clear: (options) ->
    @_context.setTransform(1, 0, 0, 1, 0, 0)
    @_context.fillStyle = options.color.toCSS()
    @_context.fillRect 0,0, @_canvas.frameWidth, @_canvas.frameHeight

  setTransform: (options) ->
    transform = @_referenceFrame.clone()
    transform.multiply options.matrix

    values = transform.values
    devicePixelRatio = @_canvas._devicePixelRatio

    if @flipYAxis
      scale = 1
      yPosition = values[5]
    else
      scale = -1
      yPosition = @_canvas._height - values[5]

    @_context.setTransform(
      devicePixelRatio * values[0],
      devicePixelRatio * scale * values[1],
      devicePixelRatio * scale * values[2],
      devicePixelRatio * values[3],
      devicePixelRatio * values[4],
      devicePixelRatio * yPosition)

  drawInReferenceFrame: (options) ->
    @setTransform matrix: options.referenceFrame
    @_referenceFrame = options.referenceFrame

    iterateThroughNestedArrays [options.commands], (command) =>
      @execute(command)

    @_referenceFrame = new Matrix2d()

  drawText: (options) ->
    @_context.textBaseline = "top"
    @_context.font = "#{options.fontSize}px monospace"
    @_context.fillStyle = options.color
    @_context.fillText(options.text, 0, 0)

  drawImage: (options) ->
    image = options.image
    crop = options.crop
    origin = options.origin

    Profiler.incrementCounter "drawImage"

    @_context.drawImage(
      image,
      crop.x, #source X
      crop.y, #source Y
      crop.width,  #source width
      crop.height, #source height
      -origin[0], #destination X
      -origin[1], #destination Y
      crop.width, #destination width
      crop.height) #destination height

`export default CanvasRenderer`

