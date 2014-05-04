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
    it "defaults to [0,0]", ->
      t = new TransformNode()
      expect(t.position).toEqual [0,0]

    it "modifies the transformation matrix when re-assigning", ->
      t = new TransformNode()
      position = [4,5]
      t.position = position
      expect(t.matrix.values).toEqual new Matrix2d().translate(position[0], position[1]).values

    it "modifies the transformation matrix when updating an individual vector component", ->
      t = new TransformNode()
      t.position[0] += 10
      expect(t.matrix.values).toEqual new Matrix2d().translate(10, 0).values

  describe "composite transform", ->
    it "should rotate, then translate", ->
      t = new TransformNode()
      t.position = [1,2]
      t.rotation = 4
      expect(t.matrix.values).toEqual new Matrix2d().translate(1,2).rotate(4).values
