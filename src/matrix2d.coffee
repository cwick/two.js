`module gl from "lib/gl-matrix"`

class Matrix2d
  constructor: (values) ->
    @values = gl.mat2d.create()

    @values.set values if values

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
