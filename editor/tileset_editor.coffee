define ["jquery", "./lib/control"], ($, Control) ->
  class TilesetEditor extends Control
    constructor: ->
      super
      @$domElement.append(
        """
        <div style="overflow: auto">
          <img src="assets/default.png">
        </div>
        """
      )
