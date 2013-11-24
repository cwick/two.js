define ["./shape"], (Shape) ->
  class Disc extends Shape
    constructor: (options={}) ->
      super
      @radius = options.radius ?= 5
      unless options.name
        @setName "Disc (#{@getId()})"

    updateBoundingDisc: (disc) ->
      disc.setPosition @getPosition()
      disc.setRadius @radius * @getScale()

    updateBoundingBox: (box) ->
      box.setPosition @getPosition()
      box.setWidth @getScale()*@radius*2
      box.setHeight @getScale()*@radius*2

