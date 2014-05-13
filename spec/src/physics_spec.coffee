`import Physics from "components/physics"`
`import Transform from "components/transform"`
`import TwoObject from "object"`

describe "Components.Physics", ->
  beforeEach ->
    @obj = TwoObject.createWithMixins Physics, Transform

  xit "requires the Transform component", ->
    expect(-> TwoObject.extend Physics).toThrow()

  it "has 0 velocity by default", ->
    expect(@obj.physics.velocity).toEqual [0,0]

  it "can set velocity with an array", ->
    @obj.physics.velocity = [1,2]
    expect(@obj.physics.velocity).toEqual [1,2]

  it "can set velocity with array indices", ->
    @obj.physics.velocity[0] = 3
    @obj.physics.velocity[1] = 4
    expect(@obj.physics.velocity[0]).toEqual 3
    expect(@obj.physics.velocity[1]).toEqual 4

  it "can set velocity with x and y", ->
    @obj.physics.velocity.x = 6
    @obj.physics.velocity.y = 7
    expect(@obj.physics.velocity.x).toEqual 6
    expect(@obj.physics.velocity.y).toEqual 7
    expect(@obj.physics.velocity).toEqual [6,7]

