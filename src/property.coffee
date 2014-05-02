class PropertyMarker
  constructor: (@options) ->

  @setupProperties: (object) ->
    for k,v of object
      if v instanceof PropertyMarker
        Object.defineProperty object, k, {
          get: v.options.get
        }

    object

Property = (options) -> new PropertyMarker(options)

`export default Property`
`export { PropertyMarker }`

