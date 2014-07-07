`import CanGroup from "can_group"`
`import CanHaveParent from "can_have_parent"`
`import TwoObject from "object"`

GroupNode = null
LeafNode = null

describe "CanGroup", ->
  beforeEach ->
    GroupNode = TwoObject.extend CanGroup, CanHaveParent
    LeafNode = TwoObject.extend CanHaveParent

  it "starts with no children", ->
    node = new GroupNode()
    expect(node.children.length).toEqual 0

  describe "when adding children", ->
    parent = child = null

    beforeEach ->
      parent = new GroupNode()
      child = new GroupNode()

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
      parent = new GroupNode()
      child = new LeafNode()

      parent.add child
      parent.remove child

    it "updates its 'children' collection", ->
      expect(parent.children.length).toEqual 0

    it "clears the 'parent' property of its former children", ->
      expect(child.parent).toBeNull()

  describe "when removing all children", ->
    it "removes all children", ->
      parent = new GroupNode()
      child1 = new GroupNode()
      child2 = new GroupNode()

      parent.add child1
      parent.add child2

      parent.removeAll()
      expect(parent.children.length).toEqual 0
      expect(child1.parent).toBeNull()
      expect(child2.parent).toBeNull()

  describe "when adding a group to multiple parents", ->
    parent1 = parent2 = child = null

    beforeEach ->
      child = new GroupNode()
      parent1 = new GroupNode()
      parent2 = new GroupNode()

      parent1.add child
      parent2.add child

    it "gets removed from its former parent", ->
      expect(child.parent).toBe parent2
      expect(parent1.children).toEqual []
      expect(parent2.children).toEqual [child]

  describe "when adding a leaf to multiple parents", ->
    parent1 = parent2 = child = null

    beforeEach ->
      child = new LeafNode()
      parent1 = new GroupNode()
      parent2 = new GroupNode()

      parent1.add child
      parent2.add child
