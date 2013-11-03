define ->
  class BoundingBox
    constructor: (options) ->
      @x = options.x ?= 0
      @y = options.y ?= 0
      @width = options.width ?= 10
      @height = options.height ?= 10

    intersectsWith: (point) =>
      point[1] <= @y + @height/2 &&
        point[1] >= @y - @height/2 &&
        point[0] <= @x + @width/2 &&
        point[0] >= @x - @width/2


