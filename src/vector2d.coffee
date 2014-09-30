`module gl from "./lib/gl-matrix"`

Vector2d = (values) ->
  if values?
    @[0] = values[0]
    @[1] = values[1]
  else
    @[0] = 0
    @[1] = 0
  return

Vector2d:: = new Array(2)
Vector2d::applyMatrix = (matrix) ->
  gl.vec2.transformMat2d(@, @, matrix.values)
  @

Object.defineProperty Vector2d::, "x",
  set: (value) -> @[0] = value
  get: -> @[0]

Object.defineProperty Vector2d::, "y",
  set: (value) -> @[1] = value
  get: -> @[1]

`export default Vector2d`
