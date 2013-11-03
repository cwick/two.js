define ["gl-matrix", "./material"], (gl, Material) ->
  class Disc
    constructor: (options) ->
      @radius = options.radius ?= 5
      @material = options.material ?= new Material()
      @x = options.x ?= 0
      @y = options.y ?= 0

    getBoundingBox: ->
      intersectsWith: (point) =>
        point[1] <= @y + @radius &&
          point[1] >= @y - @radius &&
          point[0] <= @x + @radius &&
          point[0] >= @x - @radius

    getBoundingDisc: ->
      intersectsWith: (point) =>
        center = gl.vec2.fromValues(@x, @y)
        gl.vec2.distance(center, point) <= @radius


