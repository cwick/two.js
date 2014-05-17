`import RigidBody from "components/rigid_body"`
`import Transform from "components/transform"`
`import TwoObject from "object"`
`import PhysicsWorld from "physics_world"`
`module p2 from "lib/p2"`

describe "Components.RigidBody", ->
  beforeEach ->
    @obj = TwoObject.createWithMixins RigidBody, Transform

  xit "requires the Transform component", ->
    expect(-> TwoObject.extend RigidBody).toThrow()

  it "calculates position in a zero-g environment", ->
    @obj.rigidBody.motionState = p2.Body.DYNAMIC
    @obj.rigidBody.velocity = [60, 0]

    world = new PhysicsWorld()
    world.p2.gravity = [0, 0]
    world.add @obj
    world.step 1/60

    expect(@obj.transform.position.x).toBeCloseTo 1


