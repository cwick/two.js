define ["gl-matrix"], (gl) ->
  class Projector
    constructor: (@camera, @renderer) ->

    pick: (screenPoint, scene) ->
      picked = @camera.pick @normalizeScreenPoint(screenPoint, @renderer), scene
      # if picked? then picked else @_pick screenPoint, scene

    project: (worldPoint) ->
      @denormalizeScreenPoint @camera.project(worldPoint)

    unproject: (screenPoint) ->
      @camera.unproject @normalizeScreenPoint(screenPoint, @renderer)

    normalizeScreenPoint: (screenPoint) ->
      gl.vec2.fromValues(
         (screenPoint[0] / @renderer.getWidth())*2 - 1,
        -(screenPoint[1] / @renderer.getHeight())*2 + 1)

    denormalizeScreenPoint: (normalizedScreenPoint) ->
      gl.vec2.fromValues(
        ( normalizedScreenPoint[0] + 1) * @renderer.getWidth()/2,
        (-normalizedScreenPoint[1] + 1) * @renderer.getHeight()/2)

    _pick: (screenPoint, scene) ->
      worldPoint = @unproject screenPoint

      for object in scene.getChildren()
        if object.material.isFixedSize &&
          @project
            object.getBoundingDisc().intersectsWith(worldPoint) &&
            object.getBoundingBox().intersectsWith(worldPoint)
          return object

        picked = @_pick normalizedScreenPoint, object
        return picked if picked?

      return null
