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
      sprite = new Sprite(material: new SpriteMaterial(image: image))

      image.loaded.add =>
        sprite.autoSize()
        @render()

      @camera.setWidth 2
      @scene.add sprite

      @render()
