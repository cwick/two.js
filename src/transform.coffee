`import GroupNode from "./group"`
`import Property from "./property"`
`import Matrix2d from "./matrix2d"`

TransformNode = GroupNode.extend
  initialize: ->
    @position = [0,0]
    @rotation = 0
    @scale = [1,1]

  matrix: Property
    get: ->
      m = new Matrix2d()
      m.translate(@position[0], @position[1]).rotate(@rotation).scale(@scale[0], @scale[1])

Object.defineProperty TransformNode.prototype, "position",
  set: (value) ->
    @_position = [value[0], value[1]]
    Object.defineProperty @_position, "x",
      get: -> @[0]
      set: (value) -> @[0] = value
    Object.defineProperty @_position, "y",
      get: -> @[1]
      set: (value) -> @[1] = value

  get: -> @_position

Object.defineProperty TransformNode.prototype, "scale",
  set: (value) ->
    @_scale = [value[0], value[1]]
    Object.defineProperty @_scale, "x",
      get: -> @[0]
      set: (value) -> @[0] = value
    Object.defineProperty @_scale, "y",
      get: -> @[1]
      set: (value) -> @[1] = value

  get: -> @_scale

`export default TransformNode`
