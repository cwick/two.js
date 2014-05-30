Vector2d = (values) ->
  if values?
    @[0] = 1.0 * values[0]
    @[1] = 1.0 * values[1]
  else
    @[0] = 0.0
    @[1] = 0.0
  return

Vector2d:: = new Array(2)

Object.defineProperty Vector2d::, "x",
  set: (value) -> @[0] = value
  get: -> @[0]

Object.defineProperty Vector2d::, "y",
  set: (value) -> @[1] = value
  get: -> @[1]

`export default Vector2d`
