define (require) ->
  $ = require "jquery"
  Camera = require "two/camera"
  CanvasRenderer = require "two/canvas_renderer"
  Dialog = require "./lib/dialog"
  Image = require "two/image"
  NumberInput = require "./lib/number_input"
  Scene = require "two/scene"
  Sprite = require "two/sprite"
  SpriteMaterial = require "two/sprite_material"

  class TilesetEditor extends Dialog
    constructor: ->
      super

      @$domElement.attr "id", "tileset-editor-dialog"

      @setTitle "Tileset"
      @setToolbar(
        """
        <span>
          <label for="tileset-grid-width">Grid size:</label>
        </span>
        <span>
          <label for="tileset-grid-height">by</label>
        </span>
        """
      )

      gridWidth = new NumberInput(digits: 3, value: 10)
      gridHeight = new NumberInput(digits: 3, value: 10)
      gridWidth.addClass "right-align"

      gridWidth.$domElement.insertAfter @$domElement.find("[for='tileset-grid-width']")
      gridHeight.$domElement.insertAfter @$domElement.find("[for='tileset-grid-height']")

      viewport = $("<div/>", class: "panel", style: "width: 400px; height: 400px")
      @_initializeScene(viewport)
      @setBody viewport

    _initializeScene: (viewport) ->
      renderer = new CanvasRenderer(width: viewport.width(), height: viewport.height())
      scene = new Scene()
      camera = new Camera(width: 2, aspectRatio: renderer.getWidth() / renderer.getHeight())

      image = new Image("assets/mario_spritesheet.png")
      sprite = new Sprite(material: new SpriteMaterial(image: image))
      image.loaded.add ->
        sprite.autoSize()
        renderer.render scene, camera

      scene.add sprite
      viewport.append renderer.domElement
