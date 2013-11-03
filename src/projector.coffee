define ["gl-matrix"], (gl) ->
  class Projector
    constructor: (@camera, @renderer) ->

    pick: (screenPoint, scene) ->
      @camera.pick @normalizeScreenPoint(screenPoint, @renderer), scene

    project: ->

    unproject: (screenPoint) ->
      @camera.unproject @normalizeScreenPoint(screenPoint, @renderer)

    normalizeScreenPoint: (screenPoint) ->
      gl.vec2.fromValues(
         (screenPoint[0] / @renderer.getWidth())*2 - 1,
        -(screenPoint[1] / @renderer.getHeight())*2 + 1)
