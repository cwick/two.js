`import Mixin from "./mixin"`
`import { PropertyMarker } from "./property"`

copyOwnProperties = (source, destination) ->
  destination[k] = v for own k,v of source when !(v instanceof PropertyMarker)
  destination

initializeObject = (properties, object, mixins=[]) ->
  mixin.apply object for mixin in mixins
  PropertyMarker.setupProperties properties, object
  object.initialize?()
  copyOwnProperties(properties, object)
  object

setupClass = (Constructor, properties) ->
  Constructor.prototype.constructor = Constructor
  Constructor.create = (properties) -> initializeObject(properties, new Constructor)
  Constructor.extend = (properties) -> extendClass(properties, Constructor)
  Constructor.toString = -> "Class"

  PropertyMarker.setupProperties properties, Constructor.prototype
  copyOwnProperties(properties, Constructor.prototype)
  wrapFunctionsForSuper(Constructor)

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
  func = Parent.__super__[funcName]
  throw new TypeError("Superclass method '#{funcName}' does not exist.") unless func
  func.apply context, args

extendClass = (properties, Base, mixins) ->
  Class = (properties={}) ->
    return initializeObject properties, @, mixins

  copyOwnProperties(Base, Class)

  Class.prototype = Object.create(Base.prototype)
  setupClass(Class, properties)

  Class.__super__ = Base.prototype
  Class

extractArguments = ->
  mixins = []
  properties = {}

  for arg,i in arguments
    if arg instanceof Mixin
      mixins.push arg
    else if arg instanceof Object
      properties = arg
      break
    else
      throw new TypeError("Arguments to 'extend' must be Mixins or Objects")

  [mixins, properties]

class TwoObject
  constructor: (properties={}) ->
    return TwoObject.create properties

  @create: (properties={}) ->
    initializeObject properties, new Object

  @extend: ->
    [mixins, properties] = extractArguments.apply @, arguments

    extendClass properties, TwoObject, mixins

  @createWithMixins: ->
    TwoObject.extend.apply(TwoObject, arguments).create()

`export default TwoObject`

