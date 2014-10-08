`import GameObject from "game_object"`
`import TransformNode from "transform_node"`

describe "GameObject", ->
  it "has a transform component by default", ->
    o = new GameObject()
    expect(o.transform instanceof TransformNode).toBe true
