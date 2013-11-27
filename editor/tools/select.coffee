define (require) ->
  gl = require "gl-matrix"
  Tool = require "./tool"

  class SelectTool extends Tool
    name: "select"

    onActivated: (e) ->
      super
      @_activeGizmo = @editor.pickGizmo(e.canvasPoint)
      object = @editor.pickSceneObject(e.canvasPoint)

      if @_activeGizmo?
        @_activeGizmo.onActivated()
      else if object?
        @editor.on.objectSelected.dispatch(object)
        @onMoved(e)
        @editor.render()
      else
        @editor.on.objectDeselected.dispatch()

    onDeactivated: ->
      super
      if @_activeGizmo?
        @editor.on.gizmoDeactivated.dispatch @_activeGizmo
        @_activeGizmo = null

    onSelected: ->
      super
      @editor.on.cursorStyleChanged.dispatch "auto"

    onMoved: (e) ->
      super
      gizmo = @editor.pickGizmo(e.canvasPoint)

      if gizmo?
        gizmo.onStylusMoved()
      else
        @editor.on.cursorStyleChanged.dispatch "auto"

    onDragged: (e) ->
      super
      if @_activeGizmo?
        @_activeGizmo.onDragged(e)
        @editor.on.gizmoDragged.dispatch @_activeGizmo


