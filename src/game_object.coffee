`import TwoObject from "./object"`

nextID = 1

GameObject = TwoObject.extend
  initialize: ->
    @id = nextID++
    @components = {}
    @_componentsByName = {}

  spawn: ->
  tick: ->
  die: ->
    @game.remove @

  addComponent: (ComponentType) ->
    component = new ComponentType(gameObject: @)
    @components[ComponentType.propertyName] = component
    @_componentsByName[ComponentType.componentName] = component
    @[ComponentType.propertyName] = component if ComponentType.hasConvenienceProperty

  hasComponent: (name) ->
    @_componentsByName[name]?

`export default GameObject`
