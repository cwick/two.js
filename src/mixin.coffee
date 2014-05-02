INIT_FUNCTION = "initialize"

class Mixin
  @create: (properties={}) -> new Mixin(properties)
  constructor: (@properties) ->

  apply: (base) ->
    if typeof @properties[INIT_FUNCTION] == "function"
      @properties[INIT_FUNCTION].apply base

    base[k] = v for own k,v of @properties when k != INIT_FUNCTION


`export default Mixin`
