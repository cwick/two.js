`import Mixin from "./mixin"`

copyOwnProperties = (source, destination) ->
  destination[k] = v for own k,v of source
  destination

createObject = (properties, Constructor) ->
  copyOwnProperties(properties, new Constructor())

setupPrototype = (properties, proto) ->
  newProperties = copyOwnProperties properties, {}

  for own k,v of properties
    if typeof v == "function"
      newProperties[k] = ->
        @_super = -> _super(@constructor, k, @, arguments)
        v.apply @, arguments

  copyOwnProperties(newProperties, proto)

_super = (Parent, funcName, context, args) ->
  Parent.__super__[funcName].apply context, args

extendClass = (properties, Base, mixin) ->
  Child = (properties={}) ->
    mixin.apply @ if mixin
    copyOwnProperties(properties, @)
    return
  Child.toString = -> "Class"

  copyOwnProperties(Base, Child)

  Child.prototype = Object.create(Base.prototype)
  setupPrototype(properties, Child.prototype)
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

