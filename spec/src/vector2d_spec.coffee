`import Vector2d from "vector2d"`

describe "Vector2d", ->
  beforeEach ->
    @vector = new Vector2d()

  it "is [0,0] by default", ->
    expect(@vector[0]).toEqual 0
    expect(@vector[1]).toEqual 0
    expect(@vector.x).toEqual 0
    expect(@vector.y).toEqual 0
    expect(@vector).toEqual [0,0]

  it "can set values in the constructor", ->
    @vector = new Vector2d([2,3])
    expect(@vector[0]).toEqual 2
    expect(@vector[1]).toEqual 3
    expect(@vector).toEqual [2,3]

  it "can be iterated like an array", ->
    expect(@vector.length).toEqual 2

    @vector[0] = 3
    @vector[1] = 4

    v = []
    v[i] = x for x,i in @vector
    expect(v).toEqual [3,4]

  it "is instanceof Array", ->
    expect(@vector instanceof Array).toBe true

  it "can be set with x and y", ->
    @vector.x = 6
    @vector.y = 7
    expect(@vector.x).toEqual 6
    expect(@vector.y).toEqual 7
    expect(@vector[0]).toEqual 6
    expect(@vector[1]).toEqual 7
    expect(@vector).toEqual [6,7]

