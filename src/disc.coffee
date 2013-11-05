define ["./object2d", "./bounding_box", "./bounding_disc"], \
       (Object2d, BoundingBox, BoundingDisc) ->

  class Disc extends Object2d
    constructor: (options) ->
      super options
      @radius = options.radius ?= 5

    updateBoundingDisc: (disc) ->
      disc.setPosition @getPosition()
      disc.setRadius @radius * @getScale()

    updateBoundingBox: (box) ->
      box.setPosition @getPosition()
      box.setWidth @getScale()*@radius*2
      box.setHeight @getScale()*@radius*2

