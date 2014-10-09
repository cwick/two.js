`import Mixin from "./mixin"`
`import { PropertyMarker } from "./property"`

INITIALIZE_FUNCTION = "initialize"

copyOwnProperties = (source, destination) ->
  destination[k] = v for own k,v of source when !(v instanceof PropertyMarker)
  destination

initializeObject = (properties, object, mixins) ->
  unless properties instanceof Object
    throw TypeError("Two.Object must be initialized with an options object.")

  for mixin in mixins when mixin.properties[INITIALIZE_FUNCTION]?
    mixin.properties[INITIALIZE_FUNCTION].apply object

  PropertyMarker.setupProperties properties, object
  object[INITIALIZE_FUNCTION]?(properties)
  copyOwnProperties(properties, object)
  object

create = (Class) ->
  return (properties) ->
    new Class(properties)

extend = (ParentClass) ->
  return ->
    [mixins, properties] = extractArguments.apply @, arguments
    allMixins = mixins.concat(ParentClass.__mixins__)

    Class = (properties={}) ->
      return initializeObject properties, @, allMixins

    copyOwnProperties(ParentClass, Class)

    Class.prototype = Object.create(ParentClass.prototype)
    setupClass(Class, ParentClass, properties, mixins)

    Class.__super__ = ParentClass.prototype
    Class.__mixins__ = allMixins
    Class

setupClass = (Class, ParentClass, properties, mixins) ->
  Class.prototype.constructor = Class
  Class.create = create(Class)
  Class.extend = extend(Class)
  Class.toString = -> "TwoObject"

  mixin.apply Class.prototype for mixin in mixins
  PropertyMarker.setupProperties properties, Class.prototype
  copyOwnProperties(properties, Class.prototype)

  if Class.prototype[INITIALIZE_FUNCTION]?
    Class.prototype[INITIALIZE_FUNCTION] = wrapInitializer(Class.prototype[INITIALIZE_FUNCTION], ParentClass)

wrapInitializer = (initializer, ParentClass) ->
  ->
    ParentClass.prototype[INITIALIZE_FUNCTION]?.apply @, arguments
    initializer.apply @, arguments

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
    return initializeObject properties, @, []

  @__mixins__: []

  @create: create(TwoObject)

  @extend: extend(TwoObject)

  @createWithMixins: ->
    TwoObject.extend.apply(TwoObject, arguments).create()

  super: (Class, method, args=[]) ->
    Class.prototype[method].apply @, args

`export default TwoObject`

