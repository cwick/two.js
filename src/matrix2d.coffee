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
    values = @values
    gl.mat2d.translate values, values, [x,y]
    @

  ###*
  # Rotate this matrix clockwise by the given angle.
  #
  # @method rotate
  # @param {Number} radians the angle, measured in radians
  # @return this matrix
  ###
  rotate: (radians) ->
    values = @values
    gl.mat2d.rotate values, values, -radians
    @

  scale: (x, y=x) ->
    values = @values
    gl.mat2d.scale values, values, [x, y]
    @

  preMultiply: (other) ->
    values = @values
    gl.mat2d.multiply values, other.values, values
    @

  multiply: (other) ->
    values = @values
    gl.mat2d.multiply values, values, other.values
    @

  invert: ->
    values = @values
    gl.mat2d.invert values, values
    @

`export default Matrix2d`
