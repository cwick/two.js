define (require) ->
  $ = require "jquery"
  EditorBase = require "./editor_base"
  EraseTool = require "./tools/erase"
  GrabTool = require "./tools/grab"
  FileSelectionDialog = require "./file_selection_dialog"
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

      @on.objectDeleted = new Signal()
      @on.projectOpened = new Signal()

      @tilesetDialog = new TilesetEditorDialog()
      @tilesetDialog.setWidth 400
      @tilesetDialog.setHeight 400
      @tilesetEditor = @tilesetDialog.editor

      @tools.push new EraseTool(@)
      @tools.push new GrabTool(@)
      @tools.push new SelectTool(@)
      @tools.push new StampTool(@)
      @tools.push new ZoomTool(@)

      @_addKeyBindings()

    run: ->
      super

      @_loadScene()
      @scene.setMaterial new SceneMaterial(backgroundColor: "#6B8CFF")

      @_selectionBox = new SelectionBox(@on)
      mainView = $(".main-view .viewport")

      new Inspector(@on).open mainView
      @tilesetDialog.open mainView
      @tilesetDialog.run()

      @on.objectDeleted.add @onObjectDeleted, @
      @on.projectOpened.add @onProjectOpened, @
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

    onObjectDeleted: (object) ->
      @on.objectDeselected.dispatch()
      @scene.remove object

    onProjectOpened: ->
      dialog = new FileSelectionDialog()
      dialog.openModal()

    _addKeyBindings: ->
      @inputBindings.addKeyBinding
        keyCode: KeyCodes.E
        onKeyDown: => @on.toolSelected.dispatch "erase"

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

    _loadScene: ->
      sceneData = window.localStorage.getItem "scene"
      if sceneData?
        @scene = new ObjectImporter().import(JSON.parse(sceneData))
