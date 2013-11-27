define (require) ->
  gl = require "gl-matrix"
  Tool = require "./tool"

  class GrabTool extends Tool
    name: "grab"

    onActivated: ->
      super

      @_initialCameraPosition = @editor.camera.getPosition()

      @editor.on.cursorStyleChanged.dispatch "-webkit-grabbing"

    onDeactivated: ->
      super
      @editor.on.cursorStyleChanged.dispatch "-webkit-grab"

    onSelected: ->
      super
      unless @isActive()
        @editor.on.cursorStyleChanged.dispatch "-webkit-grab"

    onDragged: (e) ->
      super

      newCameraPosition = gl.vec2.create()

      gl.vec2.subtract newCameraPosition, @_initialCameraPosition, e.worldTranslation

      @editor.camera.setPosition newCameraPosition
      @editor.on.objectChanged.dispatch(@editor.camera)

