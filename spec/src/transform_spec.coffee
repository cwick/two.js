`import TransformNode from "transform_node"`
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
      t.updateMatrix()
      expect(t.matrix.values).toEqual new Matrix2d().rotate(amount).values

  describe "position", ->
    it "defaults to [0,0]", ->
      t = new TransformNode()
      expect(t.position.values).toEqual [0,0]

    it "modifies the transformation matrix when re-assigning", ->
      t = new TransformNode()
      t.position = [4,5]
      t.updateMatrix()
      expect(t.matrix.values).toEqual new Matrix2d().translate(t.position.x, t.position.y).values

    it "modifies the transformation matrix when updating an individual vector component", ->
      t = new TransformNode()

      t.position.x += 10
      t.position.y += 10

      t.updateMatrix()
      expect(t.matrix.values).toEqual new Matrix2d().translate(10, 10).values

  describe "scale", ->
    it "defaults to [1,1]", ->
      t = new TransformNode()
      expect(t.scale.values).toEqual [1,1]

    it "modifies the transformation matrix when re-assigning", ->
      t = new TransformNode()
      t.scale = [4,5]
      t.updateMatrix()
      expect(t.matrix.values).toEqual new Matrix2d().scale(t.scale.x, t.scale.y).values

    it "modifies the transformation matrix when updating an individual vector component", ->
      t = new TransformNode()
      t.scale.x += 10
      t.scale.y += 10

      t.updateMatrix()
      expect(t.matrix.values).toEqual new Matrix2d().scale(11, 11).values

    it "can be scaled along both dimesions equally", ->
      t = new TransformNode()
      t.scale = 5
      t.updateMatrix()
      expect(t.matrix.values).toEqual new Matrix2d().scale(5,5).values

  describe "composite transform", ->
    it "should scale, then rotate, then translate", ->
      t = new TransformNode()
      t.position = [1,2]
      t.rotation = 4
      t.scale = [10,10]
      t.updateMatrix()
      expect(t.matrix.values).toEqual new Matrix2d().translate(1,2).rotate(4).scale(10,10).values

