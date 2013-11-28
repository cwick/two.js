define (require) ->
  gl = require "gl-matrix"
  Tool = require "./tool"

  class StampTool extends Tool
    name: "stamp"

    constructor: ->
      super
      @tileset = @editor.tilesetEditor

    onActivated: (e) ->
      super

      tile = @tileset.getCurrentTile()?.clone()
      return unless tile?

      worldPoint = @editor.projector.unproject(e.canvasPoint)
      worldPoint = @editor.snapToGrid(worldPoint, "lower-left")

      if @editor.isGridSnappingEnabled()
        tile.setOrigin [-tile.getWidth()/2, -tile.getHeight()/2]

      tile.setPosition [worldPoint[0], worldPoint[1]]

      @editor.on.objectChanged.dispatch(@editor.scene.add tile)

    onMoved: (e) ->
      super

