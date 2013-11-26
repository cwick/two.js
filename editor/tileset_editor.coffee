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
        sprite.setOrigin [-sprite.getWidth()/2, -sprite.getHeight()/2]
        @camera.setWidth sprite.getWidth()
        @camera.setPosition [sprite.getWidth()/2, sprite.getHeight()/2]
        @render()

      @scene.add sprite

    render: ->
      @renderer.clear()
      @renderer.render(@scene, @camera)
      @renderer.render(@sceneGrid, @camera)
