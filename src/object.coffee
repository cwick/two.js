`import Mixin from "./mixin"`
`import { PropertyMarker } from "./property"`

copyOwnProperties = (source, destination) ->
  destination[k] = v for own k,v of source
  destination

initializeObject = (properties, object, mixin) ->
  mixin.apply object if mixin
  copyOwnProperties(properties, object)
  PropertyMarker.setupProperties object
  object

setupPrototype = (properties, proto) ->
  copyOwnProperties(properties, proto)

  for own k,v of properties
    do (k,v) ->
      if typeof v == "function"
        proto[k] = ->
          @_super = -> _super(@constructor, k, @, arguments)
          v.apply @, arguments

_super = (Parent, funcName, context, args) ->
  Parent.__super__[funcName].apply context, args

extendClass = (properties, Base, mixin) ->
  Child = (properties={}) ->
    return initializeObject properties, @, mixin

  Child.toString = -> "Class"

  copyOwnProperties(Base, Child)

  Child.prototype = Object.create(Base.prototype)
  setupPrototype(properties, Child.prototype)
  Child.prototype.constructor = Child

  Child.__super__ = Base.prototype
  Child.create = (properties) -> initializeObject(properties, new Child)
  Child.extend = (properties) -> extendClass(properties, Child)
  Child

class TwoObject
  constructor: (properties={}) ->
    return TwoObject.create properties

  @create: (properties={}) ->
    initializeObject properties, new Object

  @extend: (mixin_or_properties={}, properties={}) ->
    if mixin_or_properties instanceof Mixin
      mixin = mixin_or_properties
    else
      properties = mixin_or_properties

    extendClass properties, TwoObject, mixin

`export default TwoObject`

