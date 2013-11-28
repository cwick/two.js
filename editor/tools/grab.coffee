define (require) ->
  gl = require "gl-matrix"
  Tool = require "./tool"

  class GrabTool extends Tool
    name: "grab"
    cursors:
      normal: "-webkit-grab"
      activated: "-webkit-grabbing"

    onActivated: ->
      super

      @_initialCameraPosition = @editor.camera.getPosition()

    onDragged: (e) ->
      super

      newCameraPosition = gl.vec2.create()

      gl.vec2.subtract newCameraPosition, @_initialCameraPosition, e.worldTranslation

      @editor.camera.setPosition newCameraPosition
      @editor.on.objectChanged.dispatch(@editor.camera)

