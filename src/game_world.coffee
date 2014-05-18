`import TwoObject from "./object"`
`import PhysicsWorld from "./physics_world"`
`import RigidBody from "./components/rigid_body"`

GameWorld = TwoObject.extend
  initialize: ->
    @objects = []
    @physics = new PhysicsWorld()

  step: (increment) ->
    obj.update?() for obj in @objects
    @physics.step increment


  add: (obj) ->
    @objects.push obj
    @physics.add obj if RigidBody.detect(obj)

`export default GameWorld`
