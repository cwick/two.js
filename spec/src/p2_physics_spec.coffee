`import P2Physics from "components/p2_physics"`
`import Transform from "components/transform"`
`import GameObject from "game_object"`
`import P2PhysicsWorld from "p2_physics_world"`
`module p2 from "lib/p2"`

describe "Components.P2Physics", ->
  beforeEach ->
    @obj = new GameObject()
    @obj.addComponent P2Physics
    @obj.addComponent Transform

  it "calculates position in a zero-g environment", ->
    console.log @obj.physics
    @obj.physics.body.motionState = p2.Body.DYNAMIC
    @obj.physics.body.velocity = [60, 0]

    world = new P2PhysicsWorld()
    world.p2.gravity = [0, 0]
    world.add @obj.physics.body
    world.tick 1/60

    expect(@obj.physics.body.position[0]).toBeCloseTo 1


