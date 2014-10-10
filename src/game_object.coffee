`import TwoObject from "./object"`
`import Log from "./log"`

GameObject = TwoObject.extend
  initialize: ->
    @components = {}
    @_componentsByName = {}

  objectDidSpawn: ->
  tick: ->
  die: ->
    @game.remove @

  addComponent: (ComponentType) ->
    return if @hasComponent(ComponentType.componentName)

    component = new ComponentType()
    @components[ComponentType.propertyName] = component
    @_componentsByName[ComponentType.componentName] = component
    component.componentWasInstalled(@)

    component

  hasComponent: (name) ->
    @_componentsByName[name]?


GameObject.__nextID__ = 1

`export default GameObject`
