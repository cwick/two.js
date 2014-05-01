class Mixin
  @create: (properties) -> new Mixin(properties)
  constructor: (@properties) ->

  extend: (base) ->
    base[k] = v for own k,v of @properties

`export default Mixin`
