`import TwoObject from "./object"`
`import Property from "./property"`
`module gl from "lib/gl-matrix"`

Matrix2d = TwoObject.extend
  initialize: ->
    @_values = gl.mat2d.create()

  values: Property readonly: true

  translate: (x, y) ->
    gl.mat2d.translate @_values, @_values, [x,y]
    @

  rotate: (radians) ->
    gl.mat2d.rotate @_values, @_values, radians
    @

`export default Matrix2d`
