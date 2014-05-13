`module gl from "lib/gl-matrix"`

Vector2d = ->
  # foo = Object.create Float32Array.prototype
  # Float32Array.constructor.call foo, 2
  # console.log foo.length
  # foo
  gl.vec2.create()
# Vector2d.prototype = new Float32Array(2)


`export default Vector2d`
