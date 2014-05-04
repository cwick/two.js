`import GroupNode from "group"`
`import Matrix2d from "matrix2d"`

class DummyMatrix
  constructor: (@name) ->
    @multiplicationOrder = [ @name ]

  multiply: (other) ->
    result = new DummyMatrix("#{@name}*#{other.name}")
    result.multiplicationOrder = @multiplicationOrder.concat other.multiplicationOrder
    result

describe "GroupNode", ->
  it "has the identity matrix by default", ->
    t = new GroupNode()
    expect(t.matrix.values).toEqual new Float32Array([1,0,0,1,0,0])

  it "has the identity world transform by default", ->
    t = new GroupNode()
    expect(t.worldMatrix.values).toEqual new Float32Array([1,0,0,1,0,0])

  it "cannot directly assign worldMatrix", ->
    t = new GroupNode()
    expect(-> t.worldMatrix = "bad").toThrow()

  it "computes a composite world transform", ->
    parent = new GroupNode()
    child = new GroupNode()
    parent.add child

    parent._matrix = new DummyMatrix("parent")
    child._matrix = new DummyMatrix("child")

    expect(child.worldMatrix.multiplicationOrder).toEqual ["parent", "child"]

  it "computes a composite world transform for a complex tree", ->
    node1 = new GroupNode()
    node2 = new GroupNode()
    node3 = new GroupNode()
    node4 = new GroupNode()

    #    node1
    #      |
    # node2 node3
    #   |
    # node4

    node1.add node2
    node1.add node3
    node2.add node4

    node1._matrix = new DummyMatrix("node1")
    node2._matrix = new DummyMatrix("node2")
    node3._matrix = new DummyMatrix("node3")
    node4._matrix = new DummyMatrix("node4")

    expect(node4.worldMatrix.multiplicationOrder).toEqual ["node1", "node2", "node4"]
    expect(node2.worldMatrix.multiplicationOrder).toEqual ["node1", "node2"]
    expect(node3.worldMatrix.multiplicationOrder).toEqual ["node1", "node3"]
    expect(node1.worldMatrix.multiplicationOrder).toEqual ["node1"]

