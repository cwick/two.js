`import P2Physics from "components/p2_physics"`
`import Transform from "components/transform"`
`import TwoObject from "object"`
`import P2PhysicsWorld from "p2_physics_world"`
`module p2 from "lib/p2"`

describe "Components.P2Physics", ->
  beforeEach ->
    @obj = TwoObject.createWithMixins P2Physics, Transform

  it "calculates position in a zero-g environment", ->
    @obj.physics.motionState = p2.Body.DYNAMIC
    @obj.physics.velocity = [60, 0]

    world = new P2PhysicsWorld()
    world.world.gravity = [0, 0]
    world.add @obj.physics
    world.step 1/60

    expect(@obj.physics.position[0]).toBeCloseTo 1


