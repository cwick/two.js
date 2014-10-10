`import TwoObject from "./object"`
`import Log from "./log"`
`import Vector2d from "./vector2d"`

GameObject = TwoObject.extend
  initialize: ->
    @components = {}
    @_componentsByName = {}
    @_inputVector = new Vector2d()

  objectDidSpawn: ->
  tick: ->
  die: ->
    @game.remove @

  consumeInputVector: ->
    v = @_inputVector
    @_inputVector = new Vector2d()
    v

  addInputVector: (v) ->
    @_inputVector.add(v)

  addComponent: (ComponentType) ->
    return if @hasComponent(ComponentType.componentName)

    component = new ComponentType(owner: @)
    @components[ComponentType.propertyName] = component
    @_componentsByName[ComponentType.componentName] = component
    component.componentWasInstalled(@)

    component

  hasComponent: (name) ->
    @_componentsByName[name]?


GameObject.__nextID__ = 1

`export default GameObject`
