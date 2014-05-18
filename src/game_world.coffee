`import TwoObject from "./object"`
`import PhysicsWorld from "./physics_world"`
`import P2Physics from "./components/p2_physics"`

GameWorld = TwoObject.extend
  initialize: ->
    @objects = []
    @physics = new PhysicsWorld()

  step: (increment) ->
    obj.update?() for obj in @objects
    @physics.step increment


  add: (obj) ->
    @objects.push obj
    @physics.add obj if P2Physics.detect(obj)

`export default GameWorld`
