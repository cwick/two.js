`import GroupNode from "./group_node"`
`import Property from "./property"`
`import Matrix2d from "./matrix2d"`
`import Vector2d from "./vector2d"`

TransformNode = GroupNode.extend
  initialize: ->
    @position = new Vector2d()
    @rotation = 0
    @scale = new Vector2d([1,1])

  updateMatrix: ->
    position = @position
    rotation = @rotation
    scale = @scale

    @_matrix.reset()
    @_matrix.translate(position.x, position.y)
    @_matrix.rotate(rotation) if rotation != 0
    @_matrix.scale(scale.x, scale.y)
    @_matrix

`export default TransformNode`
