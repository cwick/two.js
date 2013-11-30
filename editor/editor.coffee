define (require) ->
  $ = require "jquery"
  Box = require "two/box"
  Disc = require "two/disc"
  EditorBase = require "./editor_base"
  GrabTool = require "./tools/grab"
  KeyCodes = require "./key_codes"
  Image = require "two/image"
  InputBindings = require "./input_bindings"
  Inspector = require "./inspector"
  ShapeMaterial = require "two/shape_material"
  SpriteMaterial = require "two/sprite_material"
  SelectionBox = require "./selection_box"
  SelectTool = require "./tools/select"
  Signal = require "signals"
  Sprite = require "two/sprite"
  StampTool = require "./tools/stamp"
  TilesetEditorDialog = require "./tileset_editor_dialog"
  ZoomTool = require "./tools/zoom"

  class Editor extends EditorBase
    constructor: ->
      super

      @on.spriteCreated = new Signal()
      @on.objectDeleted = new Signal()

      @tilesetDialog = new TilesetEditorDialog()
      @tilesetDialog.setWidth 400
      @tilesetDialog.setHeight 400
      @tilesetEditor = @tilesetDialog.editor

      @tools.push new GrabTool(@)
      @tools.push new SelectTool(@)
      @tools.push new StampTool(@)
      @tools.push new ZoomTool(@)

      @_addKeyBindings()

    run: ->
      super

      @scene.add new Disc(radius: 3, scale: 0.7, material: new ShapeMaterial(fillColor: "#BE0028"))
      @scene.add new Disc(x:5, y:-3, radius: 2, material: new ShapeMaterial(fillColor: "green"))
      @scene.add new Box(x:-5, y:-1, width: 4, height: 6, material: new ShapeMaterial(fillColor: "yellow", strokeColor: "red"))
      @scene.add new Sprite(origin: [0, -1.93], width: 2, height: 3.86, material: new SpriteMaterial(image: new Image("assets/mario.png", => @render())))

      @_selectionBox = new SelectionBox(@on)

      $("#show-grid").change (e) => @on.gridChanged.dispatch(isVisible: $(e.target).is(':checked'))
      $("#snap-to-grid").change (e) => @on.gridSnappingChanged.dispatch($(e.target).is(':checked'))
      $("#new-sprite").click => @on.spriteCreated.dispatch()

      $("#editor").append new Inspector(@on).domElement
      $("#editor").append @tilesetDialog.domElement
      @tilesetEditor.run()

      @on.spriteCreated.add @onSpriteCreated, @
      @on.objectDeleted.add @onObjectDeleted, @
      @on.toolSelected.dispatch "select"
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

    onToolSelected: (which) ->
      super

      if which == "stamp"
        @on.objectDeselected.dispatch()

    onSpriteCreated: ->
      image = new Image "assets/default.png"
      sprite = new Sprite(material: new SpriteMaterial(image: image))

      image.loaded.add =>
        @scene.add sprite
        @on.objectSelected.dispatch sprite
        @render()

    onObjectDeleted: (object) ->
      @on.objectDeselected.dispatch()
      @scene.remove object

    _addKeyBindings: ->
      @inputBindings.addKeyBinding
        keyCode: KeyCodes.S
        onKeyDown: => @on.toolSelected.dispatch "stamp"

      @inputBindings.addKeyBinding
        keyCode: KeyCodes.DELETE
        onKeyDown: => @on.objectDeleted.dispatch @selectedObject if @selectedObject?
