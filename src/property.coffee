getPropertyOptions = (name, property, context) ->
  options = {}

  if property.options.get
    options.get = ->
      @_super = -> @constructor.__super__[name]
      property.options.get.apply(context || @)
  else if property.options.readonly
    options.get = -> (context || @)["_#{name}"]

  options

class PropertyMarker
  constructor: (@options) ->

  @setupProperties: (object, context) ->
    for own k,v of object
      if v instanceof PropertyMarker
        options = getPropertyOptions(k, v, context)
        Object.defineProperty object, k, options

    object

Property = (options={}) -> new PropertyMarker(options)

`export default Property`
`export { PropertyMarker }`

