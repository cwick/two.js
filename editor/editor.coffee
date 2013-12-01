define (require) ->
  $ = require "jquery"
  EditorBase = require "./editor_base"
  GrabTool = require "./tools/grab"
  KeyCodes = require "./key_codes"
  Image = require "two/image"
  InputBindings = require "./input_bindings"
  Inspector = require "./inspector"
  ObjectExporter = require "two/object_exporter"
  ObjectImporter = require "two/object_importer"
  SceneMaterial = require "two/scene_material"
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

      @scene = new ObjectImporter().import(JSON.parse(window.localStorage.getItem("scene")))
      @scene.setMaterial new SceneMaterial(backgroundColor: "#6989FF")

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
      @on.gridSnappingChanged.dispatch true
      @on.gridChanged.dispatch isVisible: true

      @_startAutosaving()

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

    onGridSnappingChanged: (isEnabled) ->
      super
      $("#snap-to-grid").attr "checked", isEnabled

    onGridChanged: (e) ->
      super
      if e.isVisible?
        $("#show-grid").attr "checked", e.isVisible

    _addKeyBindings: ->
      @inputBindings.addKeyBinding
        keyCode: KeyCodes.S
        onKeyDown: => @on.toolSelected.dispatch "stamp"

      @inputBindings.addKeyBinding
        keyCode: KeyCodes.DELETE
        onKeyDown: => @on.objectDeleted.dispatch @selectedObject if @selectedObject?

    _startAutosaving: ->
      save = => window.localStorage.setItem "scene", JSON.stringify(new ObjectExporter().export(@scene))
      window.setInterval save, 10 * 1000
      $(window).on "unload", save
