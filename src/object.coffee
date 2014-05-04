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

create = (Constructor) ->
  return (properties={}) ->
    initializeObject properties, new Constructor

extend = (ParentClass) ->
  return ->
    [mixins, properties] = extractArguments.apply @, arguments

    Class = (properties={}) ->
      return initializeObject properties, @, mixins.concat(ParentClass.__mixins__)

    copyOwnProperties(ParentClass, Class)

    Class.prototype = Object.create(ParentClass.prototype)
    setupClass(Class, properties)

    Class.__super__ = ParentClass.prototype
    Class.__mixins__ = mixins
    Class

setupClass = (Constructor, properties) ->
  Constructor.prototype.constructor = Constructor
  Constructor.create = create(Constructor)
  Constructor.extend = extend(Constructor)
  Constructor.toString = -> "Class"

  PropertyMarker.setupProperties properties, Constructor.prototype
  copyOwnProperties(properties, Constructor.prototype)
  wrapFunctionsForSuper(Constructor)

wrapFunctionsForSuper = (Constructor) ->
  for own key, value of Constructor.prototype when key != "constructor"
    do (key, value) ->
      if typeof value == "function"
        Constructor.prototype[key] = ->
          @_super = -> superFunction(Constructor, key, @, arguments)
          result = value.apply @, arguments
          delete @_super
          result

superFunction = (Parent, funcName, context, args) ->
  func = Parent.__super__[funcName]
  throw new TypeError("Superclass method '#{funcName}' does not exist.") unless func
  func.apply context, args

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

  @__mixins__: []

  @create: create(Object)

  @extend: extend(TwoObject)

  @createWithMixins: ->
    TwoObject.extend.apply(TwoObject, arguments).create()

`export default TwoObject`

