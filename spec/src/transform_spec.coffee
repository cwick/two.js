`import TransformNode from "transform"`
`import Matrix2d from "matrix2d"`

describe "TransformNode", ->
  describe "rotation", ->
    it "defaults to 0", ->
      t = new TransformNode()
      expect(t.rotation).toEqual 0

    it "modifies the transformation matrix", ->
      t = new TransformNode()
      amount = Math.PI
      t.rotation = amount
      expect(t.matrix.values).toEqual new Matrix2d().rotate(amount).values


  describe "position", ->
    xit "defaults to 0", ->
