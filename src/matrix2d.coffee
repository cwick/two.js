`module gl from "lib/gl-matrix"`

class Matrix2d
  constructor: (@values = gl.mat2d.create()) ->

  translate: (x, y) ->
    gl.mat2d.translate @values, @values, [x,y]
    @

  rotate: (radians) ->
    gl.mat2d.rotate @values, @values, radians
    @

  multiply: (other) ->
    result = gl.mat2d.create()
    gl.mat2d.multiply result, @values, other.values
    new Matrix2d(result)

`export default Matrix2d`
