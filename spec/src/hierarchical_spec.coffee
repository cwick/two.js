`import Hierarchical from "hierarchical"`
`import TwoObject from "object"`

Node = null

describe "Hierarchical", ->
  beforeEach ->
    Node = TwoObject.extend Hierarchical

  xit "starts with no parent and zero children", ->
    node = new Node()
    expect(node.parent).toBeNull()
    expect(node.children.length).toEqual 0

  describe "when adding children", ->
    parent = child = null

    beforeEach ->
      parent = new Node()
      child = new Node()
      parent.add child

    xit "updates its 'children' collection", ->
      expect(parent.getChildren().length).toEqual 1
      expect(parent.getChildren()[0]).toBe child

    xit "sets the 'parent' property of its children", ->
      expect(child.getParent()).toBe parent

    xit "the same child can't be added twice", ->
      parent.add child
      expect(parent.getChildren().length).toEqual 1
      expect(parent.getChildren()[0]).toBe child

