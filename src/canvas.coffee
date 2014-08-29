`import TwoObject from "./object"`
`import Property from "./property"`
`import DeviceMetrics from "./device_metrics"`

Canvas = TwoObject.extend
  initialize: ->
    @_domElement = document.createElement("canvas")
    @width = 640
    @height = 480
    @devicePixelRatio = DeviceMetrics.devicePixelRatio
    @_contexts = {}

  domElement: Property readonly: true

  getContext: (type) ->
    @_contexts[type] ||= @_domElement.getContext type

  devicePixelRatio: Property
    set: (value) ->
      @_devicePixelRatio = value
      @width = @width
      @height = @height

  width: Property
    set: (value) ->
      @_width = value
      @_domElement.width = value * @devicePixelRatio
      @_domElement.style.width = "#{value}px"

      @_setCanvasOptions()

  height: Property
    set: (value) ->
      @_height = value
      @_domElement.height = value * @devicePixelRatio
      @_domElement.style.height = "#{value}px"

      @_setCanvasOptions()

  imageSmoothingEnabled: Property
    set: (value) ->
      for _, context of @_contexts
        @_imageSmoothingEnabled =
          context.imageSmoothingEnabled =
          context.mozImageSmoothingEnabled =
          context.webkitImageSmoothingEnabled = value

  frameWidth: Property
    get: -> @_domElement.width

  frameHeight: Property
    get: -> @_domElement.height

  _setCanvasOptions: ->
    # Certain options on the Canvas DOM element must be re-enabled when width or height changes
    @imageSmoothingEnabled = @_imageSmoothingEnabled

`export default Canvas`
