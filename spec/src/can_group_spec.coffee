`import CanGroup from "can_group"`
`import CanHaveParent from "can_have_parent"`
`import TwoObject from "object"`

Node = null

describe "CanGroup", ->
  beforeEach ->
    Node = TwoObject.extend CanGroup

  it "starts with no children", ->
    node = new Node()
    expect(node.children.length).toEqual 0

  describe "when adding children", ->
    parent = child = null

    beforeEach ->
      parent = new Node()
      child = new Node()

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
      CanHaveParent.apply child
      parent.add child
      expect(child.parent).toBe parent

  describe "when removing children", ->
    parent = child = null

    beforeEach ->
      parent = new Node()
      child = new Node()

      CanHaveParent.apply child

      parent.add child
      parent.remove child

    it "updates its 'children' collection", ->
      expect(parent.children.length).toEqual 0

    it "clears the 'parent' property of its former children", ->
      expect(child.parent).toBeNull()

  describe "when adding a child to multiple parents", ->
    parent1 = parent2 = child = null

    beforeEach ->
      child = new Node()
      parent1 = new Node()
      parent2 = new Node()

      CanHaveParent.apply child

      parent1.add child
      parent2.add child

    it "gets removed from its former parent", ->
      expect(child.parent).toBe parent2
      expect(parent1.children).toEqual []
      expect(parent2.children).toEqual [child]
