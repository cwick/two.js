`import Physics from "components/physics"`
`import Transform from "components/transform"`
`import TwoObject from "object"`
`import Vector2d from "vector2d"`
`import PhysicsWorld from "physics_world"`

describe "Components.Physics", ->
  beforeEach ->
    @obj = TwoObject.createWithMixins Physics, Transform

  xit "requires the Transform component", ->
    expect(-> TwoObject.extend Physics).toThrow()

  it "has 0 velocity by default", ->
    expect(@obj.physics.velocity).toEqual [0,0]

  it "velocity is a Vector2d", ->
    expect(@obj.physics.velocity instanceof Vector2d).toBe true

  it "calculates position in a zero-g environment", ->
    @obj.physics.velocity = [60, 0]

    world = new PhysicsWorld(gravity: 0)
    world.add @obj
    world.step 1/60

    expect(@obj.transform.position.x).toBeCloseTo 1


