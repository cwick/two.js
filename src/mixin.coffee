`import { PropertyMarker } from "property"`

INIT_FUNCTION = "initialize"
META_KEY = "__two_meta__"
NEXT_ID = 1

class Mixin
  @create: (properties={}) -> new Mixin(properties, NEXT_ID++)
  constructor: (@properties, @id) ->

  detect: (base) ->
    base?[META_KEY]?[@id]?

  apply: (base) ->
    return if @detect(base)

    _context = { _base: base }

    # Call functions using the private context
    for own k,v of @properties when k != INIT_FUNCTION
      do (k,v) ->
        base[k] = v
        if typeof v == "function"
          base[k] = base[k].bind _context

    PropertyMarker.setupProperties(@properties, base, _context)

    (base[META_KEY] ?= {})[@id] = true

    if typeof @properties[INIT_FUNCTION] == "function"
      @properties[INIT_FUNCTION].apply _context

    return
`export default Mixin`
