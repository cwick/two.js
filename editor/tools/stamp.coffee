define (require) ->
  gl = require "gl-matrix"
  Tool = require "./tool"
  Utils = require "two/utils"

  class StampTool extends Tool
    name: "stamp"

    constructor: ->
      super
      @tileset = @editor.tilesetEditor

    onActivated: (e) ->
      super
      @_placeTile @editor.projector.unproject(e.canvasPoint)

    onDragged: (e) ->
      super
      @_placeTile e.worldEndPoint

    _placeTile: (worldPoint) ->
      tile = @tileset.getCurrentTile()?.clone()
      return unless tile?

      worldPoint = @editor.snapToGrid(worldPoint, "lower-left")

      if @editor.isGridSnappingEnabled()
        @_removeExistingTiles worldPoint
        tile.setOrigin [-tile.getWidth()/2, -tile.getHeight()/2]

      tile.setPosition [worldPoint[0], worldPoint[1]]

      @editor.on.objectChanged.dispatch(@editor.scene.add tile)

    _removeExistingTiles: (worldPoint) ->
      tiles = (t for t in @editor.scene.getChildren() when Utils.vectorEquals(t.getPosition(), worldPoint))
      @editor.scene.remove tile for tile in tiles

