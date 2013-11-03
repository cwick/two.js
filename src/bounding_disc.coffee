define ["gl-matrix"], (gl) ->
  class BoundingDisc
    constructor: (options) ->
      @x = options.x ?= 0
      @y = options.y ?= 0
      @radius = options.radius ?= 5
      @_squaredRadius = @radius * @radius
      @_center = gl.vec2.fromValues(@x, @y)

    intersectsWith: (point) ->
      gl.vec2.squaredDistance(@_center, point) <= @_squaredRadius



