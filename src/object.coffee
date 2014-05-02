`import Mixin from "./mixin"`

createObject = (properties, Constructor) ->
  o = new Constructor()
  o[k] = v for own k,v of properties
  o

extendClass = (properties, Base, mixin) ->
  Child = (properties={}) ->
    mixin.apply @ if mixin
    @[k] = v for own k,v of properties
    return

  Child[k] = v for own k,v of Base

  Child.prototype = Object.create(Base.prototype)
  Child.prototype[k] = v for own k,v of properties
  Child.prototype.constructor = Child

  Child.__super__ = Base.prototype
  Child.create = (properties) -> createObject(properties, Child)
  Child.extend = (properties) -> extendClass(properties, Child)
  Child

class TwoObject
  constructor: (properties={}) ->
    return TwoObject.create properties

  @create: (properties={}) ->
    createObject properties, Object

  @extend: (mixin_or_properties={}, properties={}) ->
    if mixin_or_properties instanceof Mixin
      mixin = mixin_or_properties
    else
      properties = mixin_or_properties

    extendClass properties, TwoObject, mixin

`export default TwoObject`

