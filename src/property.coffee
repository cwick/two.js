class PropertyMarker
  constructor: (@options) ->

  @setupProperties: (object) ->
    for own k,v of object
      if v instanceof PropertyMarker
        Object.defineProperty object, k, {
          get: ->
            @_super = -> @constructor.__super__[k]
            v.options.get.apply @
        }

    object

Property = (options) -> new PropertyMarker(options)

`export default Property`
`export { PropertyMarker }`

