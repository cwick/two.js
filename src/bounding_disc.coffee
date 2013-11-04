define ["gl-matrix"], (gl) ->
  class BoundingDisc
    constructor: (options={}) ->
      @_position = gl.vec2.fromValues(options.x ?= 0 , options.y ?= 0)
      @setRadius(options.radius ?= 5)

    intersectsWith: (point) ->
      gl.vec2.squaredDistance(@_position, point) <= @_squaredRadius

    getRadius: ->
      @_radius
    setRadius: (value) ->
      @_radius = value
      @_squaredRadius = @_radius * @_radius

    getPosition: ->
      gl.vec2.clone @_position
    setPosition: (value) ->
      @_position[0] = value[0]
      @_position[1] = value[1]

    getX: ->
      @_position[0]
    setX: (value) ->
      @_position[0] = value

    getY: ->
      @_position[1]
    setY: (value) ->
      @_position[1] = value

    applyMatrix: (m) ->
      gl.vec2.transformMat2d @_position, @_position, m
