define ["gl-matrix"], (gl) ->
  class Disc
    constructor: (options) ->
      @radius = options.radius ?= 5
      @color = options.color ?= "black"
      @x = options.x ?= 0
      @y = options.y ?= 0


    getBoundingDisc: ->
      intersectsWith: (point) =>
        center = gl.vec2.fromValues(@x, @y)
        gl.vec2.distance(center, point) <= @radius


