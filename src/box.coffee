define ["./material", "gl-matrix"], (Material, gl) ->
  class Box
    constructor: (options={}) ->
      @width = options.width ?= 5
      @height = options.height ?= 5
      @material = options.material ?= new Material()
      @x = options.x ?= 0
      @y = options.y ?= 0

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
