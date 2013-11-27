define (require) ->
  gl = require "gl-matrix"
  Tool = require "./tool"

  class ZoomTool extends Tool
    name: "zoom"
    constructor: ->
      super
      @zoomSpeed = 1

    onActivated: (e, amount=0.25) ->
      super
      @zoom e, amount

    onSelected: ->
      super
      @editor.on.cursorStyleChanged.dispatch "-webkit-zoom-in"

    zoom: (e, amount) ->
      width = @editor.camera.getWidth()
      # Zoom speed gets faster the more zoomed out we are
      width -= amount*@zoomSpeed*width*0.6
      width = Math.min(width, @editor.maxCameraWidth)
      width = Math.max(width, @editor.minCameraWidth)

      @editor.camera.setWidth(width)
      @editor.on.objectChanged.dispatch(@editor.camera)
