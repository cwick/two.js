INIT_FUNCTION = "initialize"

class Mixin
  @create: (properties={}) -> new Mixin(properties)
  constructor: (@properties) ->

  apply: (base) ->
    _context = {}

    if typeof @properties[INIT_FUNCTION] == "function"
      @properties[INIT_FUNCTION].apply base

    for own k,v of @properties when k != INIT_FUNCTION
      do (k,v) ->
        base[k] = v
        if typeof v == "function"
          _context._base = base
          base[k] = -> v.apply _context, arguments

    return
`export default Mixin`
