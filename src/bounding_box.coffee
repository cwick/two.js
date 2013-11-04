define ->
  class BoundingBox
    constructor: (options={}) ->
      @_x = options.x ?= 0
      @_y = options.y ?= 0
      @_width = options.width ?= 10
      @_height = options.height ?= 10

    intersectsWith: (point) =>
      point[1] <= @_y + @_height/2 &&
      point[1] >= @_y - @_height/2 &&
      point[0] <= @_x + @_width/2 &&
      point[0] >= @_x - @_width/2

    getPosition: -> [@_x, @_y]
    setPosition: (value) ->
      @_x = value[0]
      @_y = value[1]

    getWidth: -> @_width
    setWidth: (value) -> @_width = value

    getHeight: -> @_height
    setHeight: (value) -> @_height = value

    getX: -> @_x
    setX: (value) -> @_x = value

    getY: -> @_y
    setY: (value) -> @_y = value

    applyMatrix: (m) ->
