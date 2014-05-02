`import Mixin from "./mixin"`
`import { PropertyMarker } from "./property"`

copyOwnProperties = (source, destination) ->
  for own k,v of source
    Object.defineProperty destination, k,
      value: v, configurable: true, enumerable: true, writable: true

  destination

initializeObject = (properties, object, mixin) ->
  mixin.apply object if mixin
  copyOwnProperties(properties, object)
  PropertyMarker.setupProperties object
  object

setupClass = (Constructor, properties) ->
  Constructor.prototype.constructor = Constructor
  Constructor.create = (properties) -> initializeObject(properties, new Constructor)
  Constructor.extend = (properties) -> extendClass(properties, Constructor)
  Constructor.toString = -> "Class"

  copyOwnProperties(properties, Constructor.prototype)
  wrapFunctionsForSuper(Constructor)
  PropertyMarker.setupProperties Constructor.prototype

wrapFunctionsForSuper = (Constructor) ->
  for own k,v of Constructor.prototype when k != "constructor"
    do (k,v) ->
      if typeof v == "function"
        Constructor.prototype[k] = ->
          @_super = -> _super(Constructor, k, @, arguments)
          result = v.apply @, arguments
          delete @_super
          result

_super = (Parent, funcName, context, args) ->
  Parent.__super__[funcName].apply context, args

extendClass = (properties, Base, mixin) ->
  Child = (properties={}) ->
    return initializeObject properties, @, mixin

  copyOwnProperties(Base, Child)

  Child.prototype = Object.create(Base.prototype)
  setupClass(Child, properties)

  Child.__super__ = Base.prototype
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

