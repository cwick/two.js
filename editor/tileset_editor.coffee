define (require) ->
  Box = require "two/box"
  Color = require "two/color"
  EditorBase = require "./editor_base"
  Image = require "two/image"
  ShapeMaterial = require "two/shape_material"
  SpriteMaterial = require "two/sprite_material"
  Sprite = require "two/sprite"
  Styles = require "./styles"

  class TilesetEditor extends EditorBase
    run: ->
      super
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

    onStylusTouched: (e) ->
      return super if @_grabTool

      worldPoint = @projector.unproject(e.canvasPoint)
      gridWidth = @grid.getHorizontalSize()
      gridHeight = @grid.getVerticalSize()

      gridX = Math.floor(worldPoint[0] / gridWidth) * gridWidth
      gridY = Math.floor(worldPoint[1] / gridHeight) * gridHeight

      @sceneGrid.remove @_selectionBox

      @_selectionBox = new Box
        material: new ShapeMaterial(fillColor: Styles.SELECTION_COLOR.clone(a:0.5), strokeColor: "red")
        x: gridX
        y: gridY
        width: gridWidth
        height: gridHeight
        origin: [-gridWidth/2, -gridHeight/2]

      @sceneGrid.add @_selectionBox
      @on.objectChanged.dispatch @_selectionBox

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

