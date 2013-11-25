define ["jquery", "./lib/dialog", "./lib/number_input"], ($, Dialog, NumberInput) ->
  class TilesetEditor extends Dialog
    constructor: ->
      super

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
      @setBody(
        """
        <div style="overflow: auto">
          <img src="assets/default.png">
        </div>
        """
      )

      gridWidth = new NumberInput(digits: 3, value: 10)
      gridHeight = new NumberInput(digits: 3, value: 10)
      gridWidth.addClass "right-align"

      gridWidth.$domElement.insertAfter @$domElement.find("[for='tileset-grid-width']")
      gridHeight.$domElement.insertAfter @$domElement.find("[for='tileset-grid-height']")
