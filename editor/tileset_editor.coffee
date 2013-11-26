define (require) ->
  EditorBase = require "./editor_base"
  Image = require "two/image"
  SpriteMaterial = require "two/sprite_material"
  Sprite = require "two/sprite"

  class TilesetEditor extends EditorBase
    constructor: ->
      super

    run: ->
      super

      image = new Image("assets/mario_spritesheet.png")
      @_tileset = new Sprite(material: new SpriteMaterial(image: image))

      image.loaded.add =>
        @_tileset.setWidth(image.getWidth())
        @_tileset.setHeight(image.getHeight())
        @_tileset.setOrigin [-@_tileset.getWidth()/2, -@_tileset.getHeight()/2]

        @camera.setWidth @_tileset.getWidth()
        @camera.setPosition [@_tileset.getWidth()/2, @_tileset.getHeight()/2]

        @onGridChanged horizontalSize: 32, verticalSize: 32

      @scene.add @_tileset

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

