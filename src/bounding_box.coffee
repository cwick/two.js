define ["gl-matrix"], (gl) ->
  class BoundingBox
    constructor: (options={}) ->
      @_position = gl.vec2.fromValues(options.x ?= 0, options.y ?= 0)
      @_width = options.width ?= 10
      @_height = options.height ?= 10

    intersectsWith: (point) =>
      point[1] <= @_position[1] + @_height/2 &&
      point[1] >= @_position[1] - @_height/2 &&
      point[0] <= @_position[0] + @_width/2 &&
      point[0] >= @_position[0] - @_width/2

    getPosition: -> gl.vec2.clone @_position
    setPosition: (value) -> @_position = gl.vec2.clone value

    getWidth: -> @_width
    setWidth: (value) -> @_width = value

    getHeight: -> @_height
    setHeight: (value) -> @_height = value

    getX: -> @_position[0]
    setX: (value) -> @_position[0] = value

    getY: -> @_position[1]
    setY: (value) -> @_position[1] = value

    applyMatrix: (m) ->
      gl.vec2.transformMat2d @_position, @_position, m

