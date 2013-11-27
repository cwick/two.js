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
      worldPointStart = @editor.projector.unproject e.canvasPoint

      @_zoomCamera(e, amount)
      @_translateCamera(e, worldPointStart)

      @editor.on.objectChanged.dispatch(@editor.camera)

    _zoomCamera: (e, amount) ->
      width = @editor.camera.getWidth()

      # Zoom speed gets faster the more zoomed out we are
      width -= amount*@zoomSpeed*width*0.6
      width = Math.min(width, @editor.maxCameraWidth)
      width = Math.max(width, @editor.minCameraWidth)

      @editor.camera.setWidth(width)

    _translateCamera: (e, worldPointStart) ->
      worldPointEnd = @editor.projector.unproject e.canvasPoint
      @editor.camera.translate(
        worldPointStart[0] - worldPointEnd[0],
        worldPointStart[1] - worldPointEnd[1])

