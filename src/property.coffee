getPropertyOptions = (name, property, context) ->
  options = {}
  privateName = "_#{name}"

  if property.options.get
    options.get = ->
      @_super = -> @constructor.__super__[name]
      property.options.get.call(context || @)
  else
    options.get = -> (context || @)[privateName]

  if property.options.set
    options.set = (value) ->
      @_super = (value) -> @constructor.__super__[name] = value
      property.options.set.call(context || @, value)

  else if !property.options.readonly && !property.options.get?
    options.set = (value) -> (context || @)[privateName] = value

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

