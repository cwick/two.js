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
    component = new ComponentType()
    @components[ComponentType.propertyName] = component
    @_componentsByName[ComponentType.componentName] = component
    component.componentWasInstalled(@)

  hasComponent: (name) ->
    @_componentsByName[name]?

`export default GameObject`
