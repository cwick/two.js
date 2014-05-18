`import TwoObject from "./object"`
`import P2PhysicsWorld from "./p2_physics_world"`
`import P2Physics from "./components/p2_physics"`
`import ArcadePhysicsWorld from "./arcade_physics_world"`
`import ArcadePhysics from "./components/arcade_physics"`

GameWorld = TwoObject.extend
  initialize: ->
    @objects = []
    @physics =
      p2: new P2PhysicsWorld()
      arcade: new ArcadePhysicsWorld()

  step: (increment) ->
    obj.update?() for obj in @objects
    world.step increment for k, world of @physics

  add: (obj) ->
    @objects.push obj

    if P2Physics.detect(obj)
      @physics.p2.add obj
    else if ArcadePhysics.detect(obj)
      @physics.arcade.add obj

`export default GameWorld`
