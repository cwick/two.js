`import GroupNode from "./group"`
`import Property from "./property"`
`import Matrix2d from "./matrix2d"`
`import Vector2d from "./vector2d"`

TransformNode = GroupNode.extend
  initialize: ->
    @position = [0,0]
    @rotation = 0
    @scale = [1,1]

  updateMatrix: ->
    position = @_position
    rotation = @rotation
    scale = @_scale

    @_matrix.reset()
    @_matrix.translate(position[0], position[1])
    @_matrix.rotate(rotation) if rotation != 0
    @_matrix.scale(scale[0], scale[1])
    @_matrix

  position: Property
    set: (value) -> @_position = new Vector2d(value)

  scale: Property
    set: (value) ->
      if typeof value == "number"
        value = [value, value]

      @_scale = new Vector2d(value)

`export default TransformNode`
