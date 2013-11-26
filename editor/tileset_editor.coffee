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
        sprite.setWidth(image.getWidth())
        sprite.setHeight(image.getHeight())
        @camera.setWidth image.getWidth()
        @render()

      @scene.add sprite

    render: ->
      @renderer.clear()
      @renderer.render(@scene, @camera)
      @renderer.render(@sceneGrid, @camera)
