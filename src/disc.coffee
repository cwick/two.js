define ["./shape"], (Shape) ->
  class Disc extends Shape
    constructor: (options={}) ->
      super
      @radius = options.radius ?= 2
      unless options.name
        @setName "Disc (#{@getId()})"

    getBoundingWidth: -> @radius*2
    getBoundingHeight: -> @radius*2

