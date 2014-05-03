`import TwoObject from "./object"`
`import Property from "./property"`
`import DeviceMetrics from "./device_metrics"`

Canvas = TwoObject.extend
  initialize: ->
    @_domElement = document.createElement("canvas")
    @width = 640
    @height = 480

  domElement: Property readonly: true

  getContext: (type) ->
    @_domElement.getContext type

  width: Property
    set: (value) ->
      @_width = value
      @_domElement.width = value * DeviceMetrics.devicePixelRatio
      @_domElement.style.width = "#{value}px"

  height: Property
    set: (value) ->
      @_height = value
      @_domElement.height = value * DeviceMetrics.devicePixelRatio
      @_domElement.style.height = "#{value}px"

  frameWidth: Property
    get: -> @_domElement.width

  frameHeight: Property
    get: -> @_domElement.height

`export default Canvas`
