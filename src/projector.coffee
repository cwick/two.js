define ["gl-matrix", "./bounding_box"], (gl, BoundingBox) ->
  class Projector
    constructor: (@camera, @renderer) ->

    pick: (screenPoint, scene) ->
      picked = @camera.pick @normalizeScreenPoint(screenPoint, @renderer), scene
      if picked? then picked else @_pickScreenObjects screenPoint, scene

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

    getScreenBoundingBox: (object) ->
      worldBoundingBox = object.getBoundingBox()
      screenBoundingBox = new BoundingBox()
      screenBoundingBox.setPosition(@project worldBoundingBox.getPosition())

      if object.material.isFixedSize
        screenBoundingBox.setWidth(worldBoundingBox.getWidth())
        screenBoundingBox.setHeight(worldBoundingBox.getHeight())
      else
        screenBoundingBox.setWidth(
          @project([worldBoundingBox.getX() + worldBoundingBox.getWidth(), worldBoundingBox.getY()]) -
          screenBoundingBox.getX())
        screenBoundingBox.setHeight(
          @project([worldBoundingBox.getX(), worldBoundingBox.getY() + worldBoundingBox.getHeight()]) -
          screenBoundingBox.getY())

      screenBoundingBox.setX(screenBoundingBox.getX() + object.pixelOffsetX)
      screenBoundingBox.setY(screenBoundingBox.getY() + object.pixelOffsetY)
      screenBoundingBox

    _pickScreenObjects: (screenPoint, scene) ->
      worldPoint = @unproject screenPoint

      for object in scene.getChildren()
        if object.material.isFixedSize
          if @getScreenBoundingBox(object).containsPoint(screenPoint)
            return object

        picked = @_pickScreenObjects screenPoint, object
        return picked if picked?

      return null


