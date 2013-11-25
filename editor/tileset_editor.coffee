define ["jquery", "./lib/dialog"], ($, Dialog) ->
  class TilesetEditor extends Dialog
    constructor: ->
      super

      @setTitle "Tileset"
      @setToolbar(
        """
        <span>
          <label for="tileset-grid-width">Grid size:</label>
          <input id="tileset-grid-width" class="digit-3" type="number" value="10">
        </span>
        <span>
          <label for="tileset-grid-height">by</label>
          <input id="tileset-grid-height" class="digit-3" type="number" value="20">
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
