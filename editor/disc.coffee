define ->
  class Disc
    constructor: (options) ->
      @radius = options.radius ?= 5
      @color = options.color ?= "black"
      @x = options.x ?= 0
      @y = options.y ?= 0

