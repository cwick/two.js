`import SceneNode from "scene_node"`

describe "SceneNode", ->
  it "starts with no children", ->
    node = new SceneNode()
    expect(node.children.length).toEqual 0

  describe "when adding children", ->
    parent = child = null

    beforeEach ->
      parent = new SceneNode()
      child = new SceneNode()

    it "updates its 'children' collection", ->
      parent.add child
      expect(parent.children.length).toEqual 1
      expect(parent.children[0]).toBe child

    it "the same child can't be added twice", ->
      parent.add child
      parent.add child
      expect(parent.children.length).toEqual 1
      expect(parent.children[0]).toBe child

    it "sets the 'parent' property of its children", ->
      parent.add child
      expect(child.parent).toBe parent

    it "returns the child just added", ->
      expect(parent.add child).toBe child

  describe "when removing children", ->
    parent = child = null

    beforeEach ->
      parent = new SceneNode()
      child = new SceneNode()

      parent.add child
      parent.remove child

    it "updates its 'children' collection", ->
      expect(parent.children.length).toEqual 0

    it "clears the 'parent' property of its former children", ->
      expect(child.parent).toBeNull()

  describe "when removing all children", ->
    it "removes all children", ->
      parent = new SceneNode()
      child1 = new SceneNode()
      child2 = new SceneNode()

      parent.add child1
      parent.add child2

      parent.removeAll()
      expect(parent.children.length).toEqual 0
      expect(child1.parent).toBeNull()
      expect(child2.parent).toBeNull()

  describe "when adding a group to multiple parents", ->
    parent1 = parent2 = child = null

    beforeEach ->
      child = new SceneNode()
      parent1 = new SceneNode()
      parent2 = new SceneNode()

      parent1.add child
      parent2.add child

    it "gets removed from its former parent", ->
      expect(child.parent).toBe parent2
      expect(parent1.children).toEqual []
      expect(parent2.children).toEqual [child]

  describe "when adding a leaf to multiple parents", ->
    parent1 = parent2 = child = null

    beforeEach ->
      child = new SceneNode()
      parent1 = new SceneNode()
      parent2 = new SceneNode()

      parent1.add child
      parent2.add child

  it "can have a parent", ->
    node = new SceneNode()
    node._setParent(123)
    expect(node.parent).toEqual 123

  it "has no parent by default", ->
    expect(new SceneNode().parent).toBeNull()

