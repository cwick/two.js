define (require) ->
  gl = require "gl-matrix"
  Tool = require "./tool"
  Utils = require "two/utils"

  class StampTool extends Tool
    name: "stamp"

    constructor: ->
      super
      @tileset = @editor.tilesetEditor
      @tileset.on.tileSelected.add @_onTileSelected, @

    onActivated: (e) ->
      super
      @_placeTile e.worldPoint

    onDragged: (e) ->
      super
      @_placeTile e.worldEndPoint

    onDeselected: ->
      super
      @editor.sceneGizmos.remove @_previewTile
      @editor.on.objectChanged.dispatch @_previewTile

    onSelected: ->
      super
      @_onTileSelected()

    onMoved: (e) ->
      return unless @_previewTile?

      if @editor.isGridSnappingEnabled()
        @_previewTile.setOrigin [-@_previewTile.getWidth()/2, -@_previewTile.getHeight()/2]

      @_previewTile.setPosition @editor.snapToGrid(e.worldPoint, "lower-left")
      @editor.on.objectChanged.dispatch @_previewTile

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

    _onTileSelected: ->
      @editor.sceneGizmos.remove @_previewTile if @_previewTile?

      @_previewTile = @tileset.getCurrentTile().clone()

      @editor.sceneGizmos.add @_previewTile
