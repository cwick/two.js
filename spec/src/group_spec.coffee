`import GroupNode from "group_node"`
`import Matrix2d from "matrix2d"`

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

    parent._matrix = new Matrix2d([1,2,3,4,5,6])
    child._matrix = new Matrix2d([4,5,6,7,8,9])

    expect(child.updateWorldMatrix()).toEqual parent.matrix.multiply(child.matrix)

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

    node1._matrix = new Matrix2d([1,2,3,4,5,6])
    node2._matrix = new Matrix2d([5,6,7,8,9,0])
    node3._matrix = new Matrix2d([2,4,6,8,0,1])
    node4._matrix = new Matrix2d([9,8,7,6,5,4])

    node1.updateWorldMatrix()
    node2.updateWorldMatrix()
    node3.updateWorldMatrix()
    node4.updateWorldMatrix()

    expect(node4.worldMatrix).toEqual new Matrix2d().
      multiply(node1.matrix).
      multiply(node2.matrix).
      multiply(node4.matrix)
    expect(node2.worldMatrix).toEqual new Matrix2d().
      multiply(node1.matrix).
      multiply(node2.matrix)
    expect(node3.worldMatrix).toEqual new Matrix2d().
      multiply(node1.matrix).
      multiply(node3.matrix)
    expect(node1.worldMatrix).toEqual new Matrix2d().
      multiply(node1.matrix)

  it "throws an error if a child is added that does not implement CanHaveParent", ->
    expect(-> new GroupNode().add(new Object())).toThrow()
