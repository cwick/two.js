`import { DepthFirstTreeIterator } from "tree_iterators"`
`import SceneNode from "scene_node"`

iterate = (root) ->
  iterator = new DepthFirstTreeIterator(root)
  results = []

  iterator.execute (node) ->
    results.push node

  results

Node = null

describe "DepthFirstTreeIterator", ->
  beforeEach ->
    Node = SceneNode.extend
      jasmineToString: -> @name || "unnamed node"

  it "iterates over a one-node tree", ->
    node = new Node()
    results = iterate(node)

    expect(results).toEqual [node]

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
    expect(results).toEqual [root, node1, node3, node2]

  it "can handle nodes with no children", ->
    LeafNode = Object
    node = new LeafNode()
    results = iterate(node)
    expect(results).toEqual [node]

