define (require) ->
  Box = require "two/box"
  Color = require "two/color"
  EditorBase = require "./editor_base"
  GrabTool = require "./tools/grab"
  Image = require "two/image"
  ShapeMaterial = require "two/shape_material"
  Sprite = require "two/sprite"
  SpriteMaterial = require "two/sprite_material"
  Styles = require "./styles"
  Tool = require "./tools/tool"
  ZoomTool = require "./tools/zoom"

  class TileSelectTool extends Tool
    name: "tileSelect"
    onSelected: ->
      super
      @editor.on.cursorStyleChanged.dispatch "auto"

    onActivated: (e) ->
      super

      worldPoint = @editor.projector.unproject(e.canvasPoint)
      gridWidth = @editor.grid.getHorizontalSize()
      gridHeight = @editor.grid.getVerticalSize()

      gridX = Math.floor(worldPoint[0] / gridWidth) * gridWidth
      gridY = Math.floor(worldPoint[1] / gridHeight) * gridHeight

      @editor.sceneGrid.remove @_selectionBox

      @_selectionBox = new Box
        material: new ShapeMaterial(fillColor: Styles.SELECTION_COLOR.clone(a:0.5), strokeColor: "red")
        x: gridX
        y: gridY
        width: gridWidth
        height: gridHeight
        origin: [-gridWidth/2, -gridHeight/2]

      @editor.sceneGrid.add @_selectionBox
      @editor.on.objectChanged.dispatch @_selectionBox

  class TilesetEditor extends EditorBase
    constructor: ->
      super
      @tools.push new GrabTool(@)
      @tools.push new TileSelectTool(@)
      @tools.push new ZoomTool(@)

    run: ->
      super
      @on.toolSelected.dispatch "tileSelect"
      @grid.material.color = new Color("black")
      @_loadImage "assets/mario_tileset.png"

    onGridChanged: (options) ->
      if options.horizontalSize?
        @grid.setHorizontalSize options.horizontalSize
      if options.verticalSize?
        @grid.setVerticalSize options.verticalSize

      @grid.setHorizontalCells Math.round(@_tileset.getWidth()/@grid.getHorizontalSize())
      @grid.setVerticalCells Math.round(@_tileset.getHeight()/@grid.getVerticalSize())
      @grid.setOrigin [-@grid.getWidth()/2, -@grid.getHeight()/2]
      @grid.build()
      super

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
        @onGridChanged horizontalSize: 32, verticalSize: 32

