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
    @obj.physics.motionState = p2.Body.DYNAMIC
    @obj.physics.velocity = [60, 0]

    world = new P2PhysicsWorld()
    world.p2World.gravity = [0, 0]
    world.add @obj.physics
    world.tick 1/60

    expect(@obj.physics.position[0]).toBeCloseTo 1

  it "exposes a convenience property", ->
    expect(@obj.physics instanceof p2.Body).toBe true

