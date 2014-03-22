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

      @_selectionBox = new SelectionBox(@on)

      @_createInspector()
      @_createTilesetDialog()
      @_createTools()
      @_createEvents()
      @_addKeyBindings()
      @_addEventListeners()
      @_startAutosaving()

      @on.toolSelected.dispatch "select"
      @on.gridSnappingChanged.dispatch true
      @on.gridChanged.dispatch isVisible: true

      @render()

    onObjectSelected: (object) ->
      unless @_selectionBox.isAttached()
        @sceneGizmos.add @_selectionBox

      @_selectionBox.attachTo object

      @inspector.show()
      @inspector.inspect(object)
      super

    onObjectDeselected: ->
      @sceneGizmos.remove @_selectionBox
      @_selectionBox.detach()
      @inspector.clear()
      @inspector.hide()
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

    onGizmoDragged: ->
      @inspector.hide()

    onGizmoDeactivated: ->
      @inspector.show()

    setScene: (@scene) ->
      # TODO: save this with the scene
      @scene.setMaterial new SceneMaterial(backgroundColor: "#6B8CFF")

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
      return
      save = => window.localStorage.setItem "scene", JSON.stringify(new ObjectExporter().export(@scene))
      window.setInterval save, 10 * 1000
      $(window).on "unload", save

    _createEvents: ->
      @on.objectDeleted = new Signal()
      @on.projectOpened = new Signal()

    _createTilesetDialog: ->
      @tilesetDialog = new TilesetEditorDialog()
      @tilesetDialog.setWidth 400
      @tilesetDialog.setHeight 400
      @tilesetDialog.open @$domElement
      @tilesetEditor = @tilesetDialog.editor

    _createTools: ->
      @tools.push new EraseTool(@)
      @tools.push new GrabTool(@)
      @tools.push new SelectTool(@)
      @tools.push new StampTool(@)
      @tools.push new ZoomTool(@)

    _createInspector: ->
      @inspector = new Inspector(@on)
      @inspector.open @$domElement
      @inspector.hide()

    _addEventListeners: ->
      @on.objectDeleted.add @onObjectDeleted, @
      @on.projectOpened.add @onProjectOpened, @
      @on.gizmoDragged.add @onGizmoDragged, @
      @on.gizmoDeactivated.add @onGizmoDeactivated, @
