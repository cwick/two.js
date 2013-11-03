define ["gl-matrix"], (gl) ->
  class BoundingDisc
    constructor: (options={}) ->
      options.x ?= 0
      options.y ?= 0
      @setRadius(options.radius ?= 5)
      @_center = gl.vec2.fromValues(options.x, options.y)

    intersectsWith: (point) ->
      gl.vec2.squaredDistance(@_center, point) <= @_squaredRadius

    getRadius: ->
      @_radius
    setRadius: (value) ->
      @_radius = value
      @_squaredRadius = @_radius * @_radius

    getPosition: ->
      gl.vec2.clone @_center
    setPosition: (value) ->
      @_center[0] = value[0]
      @_center[1] = value[1]

    getX: ->
      @_center[0]
    setX: (value) ->
      @_center[0] = value

    getY: ->
      @_center[1]
    setY: (value) ->
      @_center[1] = value

