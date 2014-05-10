getPropertyOptions = (name, property) ->
  options = {}
  privateName = "_#{name}"

  if property.options.get
    options.get = property.options.get
  else
    options.get = -> @[privateName]

  if property.options.set
    options.set = property.options.set
  else if !property.options.readonly && !property.options.get?
    options.set = (value) -> @[privateName] = value

  options

class PropertyMarker
  constructor: (@options) ->

  @setupProperties: (properties, object) ->
    for own k,v of properties
      if v instanceof PropertyMarker
        options = getPropertyOptions(k, v)
        Object.defineProperty object, k, options

    object

Property = (options={}) -> new PropertyMarker(options)
Property.setupProperties = (prototype) -> PropertyMarker.setupProperties prototype, prototype

`export default Property`
`export { PropertyMarker }`

