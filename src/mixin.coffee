`import { PropertyMarker } from "property"`

INIT_FUNCTION = "initialize"

class Mixin
  @create: (properties={}) -> new Mixin(properties)
  constructor: (@properties) ->

  apply: (base) ->
    _context = { _base: base }

    if typeof @properties[INIT_FUNCTION] == "function"
      @properties[INIT_FUNCTION].apply _context

    for own k,v of @properties when k != INIT_FUNCTION
      do (k,v) ->
        base[k] = v
        if typeof v == "function"
          base[k] = -> v.apply _context, arguments

    PropertyMarker.setupProperties(base, _context)

    return
`export default Mixin`
