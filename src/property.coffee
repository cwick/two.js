getPropertyOptions = (name, property, context) ->
  options = {}
  getContext = -> (context || @)

  if property.options.get
    options.get = ->
      @_super = -> @constructor.__super__[name]
      property.options.get.call(getContext.call(@))
  else
    options.get = -> (getContext.call(@))["_#{name}"]

  if property.options.set
    options.set = (value) ->
      @_super = (value) -> @constructor.__super__[name] = value
      property.options.set.call(getContext.call(@), value)

  else if !property.options.readonly && !property.options.get?
    options.set = (value) -> (getContext.call(@))["_#{name}"] = value

  options

class PropertyMarker
  constructor: (@options) ->

  @setupProperties: (properties, object, context=null) ->
    for own k,v of properties
      if v instanceof PropertyMarker
        options = getPropertyOptions(k, v, context)
        Object.defineProperty object, k, options

    object

Property = (options={}) -> new PropertyMarker(options)
Property.setupProperties = (prototype) -> PropertyMarker.setupProperties prototype, prototype

`export default Property`
`export { PropertyMarker }`

