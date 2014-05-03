`import TwoObject from "./object"`
`import Property from "./property"`
`module gl from "lib/gl-matrix"`

Matrix2d = TwoObject.extend
  initialize: ->
    @_values = gl.mat2d.create()

  values: Property readonly: true

`export default Matrix2d`
