`import GameObject from "game_object"`
`import TransformNode from "transform"`

describe "GameObject", ->
  it "has a transform component by default", ->
    o = new GameObject()
    expect(o.transform instanceof TransformNode).toBe true
