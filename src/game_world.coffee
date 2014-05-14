`import TwoObject from "./object"`
`import PhysicsWorld from "./physics_world"`
`import PhysicsComponent from "./components/physics"`

GameWorld = TwoObject.extend
  initialize: ->
    @objects = []
    @physics = new PhysicsWorld()

  step: (increment) ->
    @physics.step increment

  add: (obj) ->
    @objects.push obj
    @physics.add obj if PhysicsComponent.detect(obj)

`export default GameWorld`
