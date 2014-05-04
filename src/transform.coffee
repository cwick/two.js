`import GroupNode from "./group"`
`import Property from "./property"`
`import Matrix2d from "./matrix2d"`

TransformNode = GroupNode.extend
  initialize: ->
    @rotation = 0
    @position = [0,0]

  matrix: Property
    get: ->
      m = new Matrix2d()
      m.translate(@position[0], @position[1]).rotate(@rotation)

`export default TransformNode`
