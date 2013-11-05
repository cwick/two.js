define ["./object2d", "./bounding_box", "./bounding_disc"], \
       (Object2d, BoundingBox, BoundingDisc) ->

  class Disc extends Object2d
    constructor: (options) ->
      super options
      @radius = options.radius ?= 5

    updateBoundingDisc: (disc) ->
      disc.setPosition @getPosition()
      disc.setRadius @radius

    updateBoundingBox: (box) ->
      box.setPosition @getPosition()
      box.setWidth @radius*2
      box.setHeight @radius*2

