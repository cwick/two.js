`import Transform from "transform"`

class DummyMatrix
  constructor: (@name) ->
    @multiplicationOrder = [ @name ]

  multiply: (other) ->
    result = new DummyMatrix("#{@name}*#{other.name}")
    result.multiplicationOrder = @multiplicationOrder.concat other.multiplicationOrder
    result

describe "Transform", ->
  it "has the identity matrix by default", ->
    t = new Transform()
    expect(t.matrix.values).toEqual new Float32Array([1,0,0,1,0,0])

  it "has the identity world transform by default", ->
    t = new Transform()
    expect(t.worldMatrix.values).toEqual new Float32Array([1,0,0,1,0,0])

  it "cannot directly assign worldMatrix", ->
    t = new Transform()
    expect(-> t.worldMatrix = "bad").toThrow()

  it "computes a composite world transform", ->
    parent = new Transform()
    child = new Transform()
    parent.add child

    parent.matrix = new DummyMatrix("parent")
    child.matrix = new DummyMatrix("child")

    expect(child.worldMatrix.multiplicationOrder).toEqual ["parent", "child"]

  it "computes a composite world transform for a complex tree", ->
    node1 = new Transform()
    node2 = new Transform()
    node3 = new Transform()
    node4 = new Transform()

    #    node1
    #      |
    # node2 node3
    #   |
    # node4

    node1.add node2
    node1.add node3
    node2.add node4

    node1.matrix = new DummyMatrix("node1")
    node2.matrix = new DummyMatrix("node2")
    node3.matrix = new DummyMatrix("node3")
    node4.matrix = new DummyMatrix("node4")

    expect(node4.worldMatrix.multiplicationOrder).toEqual ["node1", "node2", "node4"]
    expect(node2.worldMatrix.multiplicationOrder).toEqual ["node1", "node2"]
    expect(node3.worldMatrix.multiplicationOrder).toEqual ["node1", "node3"]
    expect(node1.worldMatrix.multiplicationOrder).toEqual ["node1"]
