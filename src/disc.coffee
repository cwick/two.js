define ["./object2d", "./bounding_box", "./bounding_disc"], \
       (Object2d, BoundingBox, BoundingDisc) ->
  class Disc extends Object2d
    constructor: (options) ->
      super options
      @radius = options.radius ?= 5

    _createBoundingDisc: ->
      new BoundingDisc(x: @x, y: @y, radius: @radius)

    _createBoundingBox: ->
      new BoundingBox(x: @x, y: @y, width: @radius*2, height: @radius*2)

