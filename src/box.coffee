define ["gl-matrix", "./material", "./object2d"], (gl, Material, Object2d) ->
  class Box extends Object2d
    constructor: (options={}) ->
      super options
      @width = options.width ?= 5
      @height = options.height ?= 5

    getBoundingDisc: ->
      intersectsWith: (point) =>
        center = gl.vec2.fromValues(@x, @y)
        gl.vec2.distance(center, point) <= gl.vec2.length(gl.vec2.fromValues(@width/2, @height/2))

    getBoundingBox: ->
      intersectsWith: (point) =>
        point[1] <= @y + @height/2 &&
          point[1] >= @y - @height/2 &&
          point[0] <= @x + @width/2 &&
          point[0] >= @x - @width/2
