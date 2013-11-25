define ["jquery", "./lib/dialog"], ($, Dialog) ->
  class TilesetEditor extends Dialog
    constructor: ->
      super

      @setTitle "Tileset"
      @setToolbar(
        """
        <input type="number" value="10">
        <input type="number" value="20">
        """
      )
      @setBody(
        """
        <div style="overflow: auto">
          <img src="assets/default.png">
        </div>
        """
      )
