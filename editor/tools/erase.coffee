define (require) ->
  Tool = require "./tool"

  class EraseTool extends Tool
    name: "erase"
    cursors:
      normal: "url(editor/cursors/eraser.png) 2 18, auto"

    onActivated: (e) ->
      super

      @_erase(e.canvasPoint)

    onDragged: (e) ->
      super

      @_erase(e.canvasEndPoint)

    _erase: (canvasPoint) ->
      object = @editor.pickSceneObject canvasPoint
      @editor.on.objectDeleted.dispatch object if object?

