`import { PropertyMarker } from "property"`

INIT_FUNCTION = "initialize"
META_KEY = "__two_meta"
NEXT_ID = 1

class Mixin
  @create: (properties={}) -> new Mixin(properties, NEXT_ID++)
  constructor: (@properties, @id) ->

  detect: (base) ->
    base?[META_KEY]?[@id]?

  apply: (base) ->
    return if @detect(base)

    _context = { _base: base }

    if typeof @properties[INIT_FUNCTION] == "function"
      @properties[INIT_FUNCTION].apply _context

    for own k,v of @properties when k != INIT_FUNCTION
      do (k,v) ->
        base[k] = v
        if typeof v == "function"
          base[k] = -> v.apply _context, arguments

    PropertyMarker.setupProperties(base, _context)

    (base[META_KEY] ?= {})[@id] = true

    return
`export default Mixin`
