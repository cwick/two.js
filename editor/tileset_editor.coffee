define (require) ->
  Box = require "two/box"
  Color = require "two/color"
  EditorBase = require "./editor_base"
  GrabTool = require "./tools/grab"
  Image = require "two/image"
  ShapeMaterial = require "two/shape_material"
  Signal = require "signals"
  Sprite = require "two/sprite"
  SpriteMaterial = require "two/sprite_material"
  Styles = require "./styles"
  Tool = require "./tools/tool"
  Utils = require "two/utils"
  ZoomTool = require "./tools/zoom"

  class TileSelectTool extends Tool
    name: "tileSelect"

    constructor: ->
      super
      @_selectionBox = new Box
        material: new ShapeMaterial(fillColor: Styles.SELECTION_COLOR.clone(a:0.5), strokeColor: "red")
        visible: false

    onSelected: ->
      super
      @editor.on.cursorStyleChanged.dispatch "auto"
      @editor.sceneGrid.add @_selectionBox
      @_selectionBox.setVisible true

    onActivated: (e) ->
      super

      @_selectionStartPoint = @editor.snapToGrid(e.worldPoint, "upper-left")
      @_selectionEndPoint = @editor.snapToGrid(e.worldPoint, "lower-right")

      @_drawSelectionBox()
      @editor.on.tileSelected.dispatch @_selectionBox

    onDragged: (e) ->
      super

      @_selectionEndPoint = @editor.snapToGrid(e.worldEndPoint, "lower-right")
      @_drawSelectionBox()
      @editor.on.tileSelected.dispatch @_selectionBox

    _drawSelectionBox: ->
      width = Math.abs(@_selectionEndPoint[0] - @_selectionStartPoint[0])
      height = Math.abs(@_selectionEndPoint[1] - @_selectionStartPoint[1])

      @_selectionBox.setPosition [@_selectionStartPoint[0], @_selectionEndPoint[1]]
      @_selectionBox.setWidth width
      @_selectionBox.setHeight height
      @_selectionBox.setOrigin [-width/2, -height/2]

  class TilesetEditor extends EditorBase
    constructor: ->
      super
      @tools.push new GrabTool(@)
      @tools.push new TileSelectTool(@)
      @tools.push new ZoomTool(@)

      Utils.merge @on,
        tileSelected: new Signal()

      @on.tileSelected.add @onTileSelected, @

    run: ->
      super
      @on.toolSelected.dispatch "tileSelect"
      @on.gridSnappingChanged.dispatch true
      @grid.getMaterial().color = new Color("black")
      @_loadImage "assets/mario_tileset.png"

    getCurrentTile: ->
      @_currentTile

    onGridChanged: ->
      super

      @grid.setHorizontalCells Math.ceil(@_tileset.getWidth()/@grid.getHorizontalSize())
      @grid.setVerticalCells Math.ceil(@_tileset.getHeight()/@grid.getVerticalSize())
      @grid.setOrigin [-@grid.getWidth()/2, -@grid.getHeight()/2]
      @grid.build()

      @render()

    onTileSelected: (selectionBox) ->
      @_currentTile = new Sprite
        width: selectionBox.getWidth() / @grid.getHorizontalSize()
        height: selectionBox.getHeight() / @grid.getVerticalSize()
        material: new SpriteMaterial
          image: @_tileset.getMaterial().image
          offsetX: selectionBox.getX()
          offsetY: selectionBox.getY()
          width: selectionBox.getWidth()
          height: selectionBox.getHeight()

      @render()

    _loadImage: (path) ->
      image = new Image(path)
      @_tileset = new Sprite(material: new SpriteMaterial(image: image))

      image.loaded.add =>
        @_tileset.setWidth(image.getWidth())
        @_tileset.setHeight(image.getHeight())
        @_tileset.setOrigin [-@_tileset.getWidth()/2, -@_tileset.getHeight()/2]

        @camera.setWidth @_tileset.getWidth()
        @camera.setPosition [@_tileset.getWidth()/2, @_tileset.getHeight()/2]

        @scene.add @_tileset
        # Force grid to recalculate based on new image size
        @on.gridChanged.dispatch(horizontalSize: @grid.getHorizontalSize(), verticalSize: @grid.getVerticalSize())

