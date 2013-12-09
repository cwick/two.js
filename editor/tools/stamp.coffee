define (require) ->
  gl = require "gl-matrix"
  Tool = require "./tool"
  Utils = require "two/utils"

  class StampTool extends Tool
    name: "stamp"
    cursors:
      normal: "url(editor/cursors/stamp.png) 12 19, auto"

    constructor: ->
      super
      @tileset = @editor.tilesetEditor
      @tileset.on.tileSelected.add @_onTileSelected, @

    onActivated: (e) ->
      super
      @_placeCurrentTileInScene e.worldPoint
      @_previewTile?.setVisible false

    onDeactivated: ->
      super
      @_previewTile?.setVisible true

    onDragged: (e) ->
      super
      @_placeCurrentTileInScene e.worldEndPoint

    onDeselected: ->
      super
      @_removePreviewTile()

    onSelected: ->
      super
      unless @_previewTile?
        @_onTileSelected()
        @onMoved @editor.getStylusPosition()

    onMoved: (e) ->
      super
      return unless @_previewTile?

      @_previewTile.setVisible true
      @_positionTile @_previewTile, e.worldPoint
      @editor.on.objectChanged.dispatch @_previewTile

    onLeftCanvas: ->
      @_previewTile?.setVisible false
      @editor.on.objectChanged.dispatch @_previewTile

    onEnteredCanvas: ->
      @_previewTile?.setVisible true
      @editor.on.objectChanged.dispatch @_previewTile

    _placeCurrentTileInScene: (worldPoint) ->
      tile = @tileset.getCurrentTile()?.clone()
      return unless tile?

      @_positionTile tile, worldPoint

      if @editor.isGridSnappingEnabled()
        @_removeExistingTiles @_snapToGrid(worldPoint)

      @editor.on.objectChanged.dispatch(@editor.scene.add tile)

    _removeExistingTiles: (worldPoint) ->
      tiles = (t for t in @editor.scene.getChildren() when Utils.vectorEquals(t.getPosition(), worldPoint))
      @editor.scene.remove tile for tile in tiles

    _onTileSelected: ->
      return unless @isSelected()
      @_setPreviewTile @tileset.getCurrentTile()?.clone()

    _setPreviewTile: (tile) ->
      @_removePreviewTile()
      @_previewTile = tile
      return unless @_previewTile?

      @_previewTile.setVisible false
      @_previewTile.setMaterial @_previewTile.getMaterial().clone(opacity: 0.5)
      @editor.sceneGizmos.add @_previewTile
      @editor.on.objectChanged.dispatch @_previewTile

    _removePreviewTile: ->
      return unless @_previewTile?
      @editor.sceneGizmos.remove @_previewTile
      @editor.on.objectChanged.dispatch @_previewTile
      @_previewTile = null

    _positionTile: (tile, worldPoint) ->
      if @editor.isGridSnappingEnabled()
        tile.setOrigin [-tile.getWidth()/2, -tile.getHeight()/2]

      tile.setPosition @_snapToGrid(worldPoint)

    _snapToGrid: (worldPoint) ->
      @editor.snapToGrid(worldPoint, "lower-left")

