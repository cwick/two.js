`import Vector2d from "vector2d"`

describe "Vector2d", ->
  beforeEach ->
    @vector = new Vector2d()

  it "is [0,0] by default", ->
    expect(@vector.x).toEqual 0
    expect(@vector.y).toEqual 0
    expect(@vector.values).toEqual [0,0]

  it "can set values in the constructor", ->
    @vector = new Vector2d([2,3])
    expect(@vector.x).toEqual 2
    expect(@vector.y).toEqual 3
    expect(@vector.values).toEqual [2,3]

  it "can be set with x and y", ->
    @vector.x = 6
    @vector.y = 7
    expect(@vector.x).toEqual 6
    expect(@vector.y).toEqual 7
    expect(@vector.values).toEqual [6,7]

  it "can be cloned", ->
    @vector.x = 3
    @vector.y = 10
    expect(@vector.clone().values).toEqual [3,10]

  it "can be added to another vector", ->
    v2 = new Vector2d([5, 6])
    @vector.x = 10
    @vector.add(v2)

    expect(@vector.values).toEqual [15, 6]

