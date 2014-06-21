`import TwoObject from "./object"`
`import Property from "./property"`

DeviceMetrics = TwoObject.createWithMixins
  devicePixelRatio: Property
    get: ->
      @_devicePixelRatio || window.devicePixelRatio

  override: (options) ->
    @["_#{key}"] = value for key, value of options


`export default DeviceMetrics`
