define (require) ->
  gl = require "gl-matrix"
  Tool = require "./tool"

  class StampTool extends Tool
    name: "stamp"

    constructor: ->
      super
      @tileset = @editor.tilesetEditor

    onActivated: ->
      super

      tile = @tileset.getCurrentTile()
      if tile?
        @editor.on.objectChanged.dispatch(@editor.scene.add tile.clone())

    onMoved: (e) ->
      super

