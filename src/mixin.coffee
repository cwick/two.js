`import { PropertyMarker } from "./property"`

INIT_FUNCTION = "initialize"
META_KEY = "__two_meta__"
NEXT_ID = 1

class Mixin
  @create: (properties={}) -> new Mixin(properties, NEXT_ID++)
  constructor: (@properties, @id) ->

  detect: (base) ->
    base[META_KEY]?[@id]?

  apply: (base) ->
    return if @detect(base)

    for own k,v of @properties when k != INIT_FUNCTION
      base[k] = v

    PropertyMarker.setupProperties(@properties, base)

    base[META_KEY] = @_createMetaData(base[META_KEY])

    return

  _createMetaData: (baseMeta = {}) ->
    meta = {}
    meta[k] = v for own k,v of baseMeta
    meta[@id] = true

    meta

`export default Mixin`
