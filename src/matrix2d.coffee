`module gl from "lib/gl-matrix"`

class Matrix2d
  constructor: (values) ->
    @values = gl.mat2d.create()

    if values
      @values[0] = values[0]
      @values[1] = values[1]
      @values[2] = values[2]
      @values[3] = values[3]
      @values[4] = values[4]
      @values[5] = values[5]

  reset: ->
    gl.mat2d.identity @values
    @

  clone: ->
    new Matrix2d(@values)

  translate: (x, y) ->
    gl.mat2d.translate @values, @values, [x,y]
    @

  rotate: (radians) ->
    gl.mat2d.rotate @values, @values, radians
    @

  scale: (x, y=x) ->
    gl.mat2d.scale @values, @values, [x, y]
    @

  multiply: (other) ->
    gl.mat2d.multiply @values, @values, other.values
    @

`export default Matrix2d`
