define (require) ->
  gl = require "gl-matrix"
  Tool = require "./tool"

  class ZoomTool extends Tool
    name: "zoom"
    cursors:
      normal: "-webkit-zoom-in"

    constructor: ->
      super
      @zoomSpeed = 1

    onActivated: (e, amount=0.25) ->
      super
      @zoom canvasPoint: e.canvasPoint, amount: amount

    zoom: (options) ->
      worldPointStart = @editor.projector.unproject options.canvasPoint

      @_zoomCamera(options.amount)
      @_translateCamera(options.canvasPoint, worldPointStart)

      @editor.on.objectChanged.dispatch(@editor.camera)

    _zoomCamera: (amount) ->
      width = @editor.camera.getWidth()

      # Zoom speed gets faster the more zoomed out we are
      width -= amount*@zoomSpeed*width*0.6
      width = Math.min(width, @editor.maxCameraWidth)
      width = Math.max(width, @editor.minCameraWidth)

      @editor.camera.setWidth(width)

    _translateCamera: (canvasPointEnd, worldPointStart) ->
      worldPointEnd = @editor.projector.unproject canvasPointEnd
      @editor.camera.translate(
        worldPointStart[0] - worldPointEnd[0],
        worldPointStart[1] - worldPointEnd[1])

