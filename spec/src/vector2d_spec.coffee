`import Vector2d from "vector2d"`

describe "Vector2d", ->
  beforeEach ->
    @vector = new Vector2d()

  it "is [0,0] by default", ->
    console.log @vector
    console.log @vector.length
    expect(@vector[0]).toEqual 0
    # expect(@vector[1]).toEqual 0
    # expect(@vector.x).toEqual 0
    # expect(@vector.y).toEqual 0
    # expect(@vector).toEqual [0,0]

