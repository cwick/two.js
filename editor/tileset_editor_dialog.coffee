define (require) ->
  Dialog = require "./lib/dialog"
  NumberInput = require "./lib/number_input"
  TilesetEditor = require "./tileset_editor"

  class TilesetEditorDialog extends Dialog
    constructor: ->
      super

      @$domElement.find(".dialog-body").addClass "no-padding"

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

      gridWidth = new NumberInput(id: "tileset-grid-width", digits: 3, value: 32)
      gridHeight = new NumberInput(id: "tileset-grid-height", digits: 3, value: 32)
      gridWidth.addClass "right-align"

      gridWidth.$domElement.insertAfter @$domElement.find("[for='tileset-grid-width']")
      gridHeight.$domElement.insertAfter @$domElement.find("[for='tileset-grid-height']")

      gridWidth.changed.add => @editor.on.gridChanged.dispatch(horizontalSize: gridWidth.getValue())
      gridHeight.changed.add => @editor.on.gridChanged.dispatch(verticalSize: gridHeight.getValue())

      @editor = new TilesetEditor()
      @setBody @editor.domElement
      @setTranslation 50, 150
