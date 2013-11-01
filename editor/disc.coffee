define ->
  class Disc
    constructor: (options) ->
      @radius = options.radius ?= 5
      @color = options.color ?= "black"
      @x = @y = 0

