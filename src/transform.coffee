`import GroupNode from "./group"`
`import Property from "./property"`
`import Matrix2d from "./matrix2d"`

TransformNode = GroupNode.extend
  initialize: ->
    @position = [0,0]
    @rotation = 0
    @scale = [1,1]
    @origin = [0,0]

  matrix: Property
    get: ->
      m = new Matrix2d()
      m.translate(@position[0], @position[1]).
        rotate(@rotation).
        scale(@scale[0], @scale[1]).

        translate(-@origin[0], -@origin[1])

  # Map position[0] to position.x and position[1] to position.y
  position: Property
    set: (value) ->
      @_position = [value[0], value[1]]
      Object.defineProperty @_position, "x",
        get: -> @[0]
        set: (value) -> @[0] = value
      Object.defineProperty @_position, "y",
        get: -> @[1]
        set: (value) -> @[1] = value

  # Map scale[0] to scale.x and scale[1] to scale.y
  scale: Property
    set: (value) ->
      if typeof value == "number"
        value = [value, value]

      @_scale = [value[0], value[1]]
      Object.defineProperty @_scale, "x",
        get: -> @[0]
        set: (value) -> @[0] = value
      Object.defineProperty @_scale, "y",
        get: -> @[1]
        set: (value) -> @[1] = value

    get: -> @_scale

  # Map origin[0] to origin.x and origin[1] to origin.y
  origin: Property
    set: (value) ->
      @_origin = [value[0], value[1]]
      Object.defineProperty @_origin, "x",
        get: -> @[0]
        set: (value) -> @[0] = value
      Object.defineProperty @_origin, "y",
        get: -> @[1]
        set: (value) -> @[1] = value

    get: -> @_origin

`export default TransformNode`
