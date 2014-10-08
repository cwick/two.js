`import SceneNode from "scene_node"`

describe "SceneNode", ->
  it "can have a parent", ->
    node = new SceneNode()
    node._setParent(123)
    expect(node.parent).toEqual 123

  it "has no parent by default", ->
    expect(new SceneNode().parent).toBeNull()


