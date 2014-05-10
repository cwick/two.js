`import Mixin from "./mixin"`
`import { PropertyMarker } from "./property"`

copyOwnProperties = (source, destination) ->
  destination[k] = v for own k,v of source when !(v instanceof PropertyMarker)
  destination

initializeObject = (properties, object, mixins) ->
  mixin.properties.initialize.apply object for mixin in mixins when mixin.properties.initialize?
  PropertyMarker.setupProperties properties, object
  object.initialize?()
  copyOwnProperties(properties, object)
  object

create = (Constructor) ->
  return (properties={}) ->
    initializeObject properties, new Constructor, []

extend = (ParentClass) ->
  return ->
    [mixins, properties] = extractArguments.apply @, arguments
    allMixins = mixins.concat(ParentClass.__mixins__)

    Class = (properties={}) ->
      return initializeObject properties, @, allMixins

    copyOwnProperties(ParentClass, Class)

    Class.prototype = Object.create(ParentClass.prototype)
    setupClass(Class, properties, mixins)

    Class.__super__ = ParentClass.prototype
    Class.__mixins__ = allMixins
    Class

setupClass = (Constructor, properties, mixins) ->
  Constructor.prototype.constructor = Constructor
  Constructor.create = create(Constructor)
  Constructor.extend = extend(Constructor)
  Constructor.toString = -> "Class"

  mixin.apply Constructor.prototype for mixin in mixins
  PropertyMarker.setupProperties properties, Constructor.prototype
  copyOwnProperties(properties, Constructor.prototype)
  Constructor.prototype._super = superFunction

superFunction = (Parent, property) ->
  parentProperty = Parent.prototype[property]
  throw new TypeError("Superclass property '#{property}' does not exist.") unless parentProperty?
  if typeof parentProperty == "function"
    parentProperty = parentProperty.bind @
  parentProperty

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

