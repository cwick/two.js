define (require) ->
  $ = require "jquery"
  gl = require "gl-matrix"
  Box = require "two/box"
  Disc = require "two/disc"
  EditorBase = require "./editor_base"
  Image = require "two/image"
  Inspector = require "./inspector"
  ShapeMaterial = require "two/shape_material"
  SpriteMaterial = require "two/sprite_material"
  SelectionBox = require "./selection_box"
  Signal = require "signals"
  Sprite = require "two/sprite"
  TilesetEditor = require "./tileset_editor"
  Utils = require "two/utils"

  class Editor extends EditorBase
    constructor: ->
      super

      Utils.merge @on,
        spriteCreated: new Signal()

    run: ->
      super

      @scene.add new Disc(radius: 3, scale: 0.7, material: new ShapeMaterial(fillColor: "#BE0028"))
      @scene.add new Disc(x:5, y:-3, radius: 2, material: new ShapeMaterial(fillColor: "green"))
      @scene.add new Box(x:-5, y:-1, width: 4, height: 6, material: new ShapeMaterial(fillColor: "yellow", strokeColor: "red"))
      @scene.add new Sprite(width: 2, height: 3.86, material: new SpriteMaterial(image: new Image("assets/mario.png", => @render())))

      @_selectionBox = new SelectionBox(@on)

      $("#show-grid").change (e) => @on.gridChanged.dispatch(isVisible: $(e.target).is(':checked'))
      $("#snap-to-grid").change (e) => @on.gridSnappingChanged.dispatch(enabled: $(e.target).is(':checked'))
      $("#grab-tool").click => @on.grabToolSelected.dispatch()
      $("#new-sprite").click => @on.spriteCreated.dispatch()

      $("#editor").append (new Inspector(@on)).domElement
      $("#editor").append (new TilesetEditor()).domElement

      @on.spriteCreated.add @onSpriteCreated, @
      @render()

    onObjectSelected: (object) ->
      unless @_selectionBox.isAttached()
        @sceneGizmos.add @_selectionBox

      @_selectionBox.attachTo object

      super

    onObjectDeselected: ->
      @sceneGizmos.remove @_selectionBox
      @_selectionBox.detach()
      super

    onSpriteCreated: ->
      image = new Image "assets/default.png"
      sprite = new Sprite(material: new SpriteMaterial(image: image))

      image.loaded.add =>
        @scene.add sprite
        @on.objectSelected.dispatch sprite
        @render()

