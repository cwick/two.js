`import Hierarchical from "hierarchical"`
`import TwoObject from "object"`

Node = null

describe "Hierarchical", ->
  beforeEach ->
    Node = TwoObject.extend Hierarchical

  it "starts with no parent and zero children", ->
    node = new Node()
    expect(node.parent).toBeNull()
    expect(node.children.length).toEqual 0

  describe "when adding children", ->
    parent = child = null

    beforeEach ->
      parent = new Node()
      child = new Node()
      parent.add child

    it "updates its 'children' collection", ->
      expect(parent.children.length).toEqual 1
      expect(parent.children[0]).toBe child

    it "sets the 'parent' property of its children", ->
      expect(child.parent).toBe parent

    it "the same child can't be added twice", ->
      parent.add child
      expect(parent.children.length).toEqual 1
      expect(parent.children[0]).toBe child

  describe "when adding a child to multiple parents", ->
    parent1 = parent2 = child = null

    beforeEach ->
      child = new Node()
      parent1 = new Node()
      parent2 = new Node()

      parent1.add child
      parent2.add child

    it "gets removed from its former parent", ->
      expect(child.parent).toBe parent2
      expect(parent1.children).toEqual []
      expect(parent2.children).toEqual [child]

  describe "when removing children", ->
    parent = child = null

    beforeEach ->
      parent = new Node()
      child = new Node()
      parent.add child
      parent.remove child

    it "updates its 'children' collection", ->
      expect(parent.children.length).toEqual 0

    it "clears the 'parent' property of its former children", ->
      expect(child.parent).toBeNull()

