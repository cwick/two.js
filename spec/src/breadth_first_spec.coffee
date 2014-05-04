`import TwoObject from "object"`
`import CanGroup from "can_group"`
`import { BreadthFirstTreeIterator } from "tree_iterators"`

iterate = (root) ->
  iterator = new BreadthFirstTreeIterator(root)
  results = []

  while iterator.hasNext
    results.push iterator.next()

  results

Node = null

describe "BreadthFirstTreeIterator", ->
  beforeEach ->
    Node = TwoObject.extend CanGroup,
      jasmineToString: -> @name || "unnamed node"

  it "iterates over a zero-node tree", ->
    results = iterate()
    expect(results).toEqual []

  it "iterates over a one-node tree", ->
    node = new Node()
    results = iterate(node)

    expect(results).toEqual [node]

  it "returns null if next is called when iterating finished", ->
    iterator = new BreadthFirstTreeIterator()
    expect(iterator.hasNext).toBe false
    expect(iterator.next()).toBeNull()

  it "iterates over a two-node tree", ->
    node1 = new Node(name: "node1")
    node2 = new Node(name: "node2")
    node1.add node2

    results = iterate(node1)

    expect(results).toEqual [node1, node2]

  it "iterates over a tree with height 2", ->
    root = new Node(name: "root")
    node1 = new Node(name: "node1")
    node2 = new Node(name: "node2")

    root.add node1
    root.add node2

    results = iterate(root)
    expect(results).toEqual [root, node1, node2]

  it "iterates over a complex tree", ->
    root = new Node(name: "root")
    node1 = new Node(name: "node1")
    node2 = new Node(name: "node2")
    node3 = new Node(name: "node3")

    #    root
    #      |
    # node1 node2
    #  |
    # node3

    root.add node1
    root.add node2
    node1.add node3

    results = iterate(root)
    expect(results).toEqual [root, node1, node2, node3]
