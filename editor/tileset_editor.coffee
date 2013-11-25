define ["jquery", "./lib/control"], ($, Control) ->
  class TilesetEditor extends Control
    constructor: ->
      super $("<div/>", class: "panel-vertical")
      @$domElement.append(
        """
        <div class="panel">
          <input type="text" style="background-color:blue" value="10">
          <input type="text" style="background-color:green" value="20">
          <span style="background-color:red"></span>
        </div>
        <div style="overflow: auto">
          <img src="assets/default.png">
        </div>
        """
      )
