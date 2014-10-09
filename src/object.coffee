`import { PropertyMarker } from "./property"`

INITIALIZE_FUNCTION = "initialize"

copyOwnProperties = (source, destination) ->
  destination[k] = v for own k,v of source when !(v instanceof PropertyMarker)
  destination

initializeObject = (properties, object) ->
  unless properties instanceof Object
    throw TypeError("Two.Object must be initialized with an options object.")

  PropertyMarker.setupProperties properties, object
  object[INITIALIZE_FUNCTION]?(properties)
  copyOwnProperties(properties, object)
  object

create = (Class) ->
  return (properties) ->
    new Class(properties)

extend = (ParentClass) ->
  return ->
    properties = extractArguments.apply @, arguments

    Class = (properties={}) ->
      return initializeObject properties, @

    copyOwnProperties(ParentClass, Class)

    Class.prototype = Object.create(ParentClass.prototype)
    setupClass(Class, ParentClass, properties)

    Class.__super__ = ParentClass.prototype
    Class

setupClass = (Class, ParentClass, properties) ->
  Class.prototype.constructor = Class
  Class.create = create(Class)
  Class.extend = extend(Class)
  Class.toString = -> "TwoObject"

  PropertyMarker.setupProperties properties, Class.prototype
  copyOwnProperties(properties, Class.prototype)

  if Class.prototype[INITIALIZE_FUNCTION]?
    Class.prototype[INITIALIZE_FUNCTION] = wrapInitializer(Class.prototype[INITIALIZE_FUNCTION], ParentClass)

wrapInitializer = (initializer, ParentClass) ->
  ->
    ParentClass.prototype[INITIALIZE_FUNCTION]?.apply @, arguments
    initializer.apply @, arguments

extractArguments = ->
  properties = {}

  for arg,i in arguments
    if arg instanceof Object
      properties = arg
      break
    else
      throw new TypeError("Argument to 'extend' must be Objects")

  properties

class TwoObject
  constructor: (properties={}) ->
    return initializeObject properties, @, []

  @create: create(TwoObject)

  @extend: extend(TwoObject)

  @extendAndCreate: ->
    TwoObject.extend.apply(TwoObject, arguments).create()

  super: (Class, method, args=[]) ->
    Class.prototype[method].apply @, args

`export default TwoObject`

