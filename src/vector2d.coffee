`module gl from "./lib/gl-matrix"`

class Vector2d
  constructor: (values) ->
    @values = gl.vec2.create()

    @setValues(values) if values

  clone: ->
    new Vector2d(@values)

  setValues: (values) ->
    @values[0] = values[0]
    @values[1] = values[1]

  applyMatrix: (matrix) ->
    values = @values
    gl.vec2.transformMat2d(values, values, matrix.values)
    @

  add: (other) ->
    valus = @values
    gl.vec2.add(values, values, other.values)
    @

  normalize: ->
    values = @values
    gl.vec2.normalize(values, values)
    @

Object.defineProperty Vector2d::, "x",
  set: (value) -> @values[0] = value
  get: -> @values[0]

Object.defineProperty Vector2d::, "y",
  set: (value) -> @values[1] = value
  get: -> @values[1]

`export default Vector2d`
