define ["./object2d", "./bounding_box", "./bounding_disc"], \
       (Object2d, BoundingBox, BoundingDisc) ->

  class Disc extends Object2d
    constructor: (options) ->
      super options
      @radius = options.radius ?= 5

    _createBoundingDisc: ->
      new BoundingDisc(x: @_x, y: @_y, radius: @radius)

    _createBoundingBox: ->
      new BoundingBox(x: @_x, y: @_y, width: @radius*2, height: @radius*2)

