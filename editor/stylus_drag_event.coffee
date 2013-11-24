define ["gl-matrix", "two/utils"], (gl, Utils) ->
  class StylusDragEvent
    constructor: (options={}) ->
      options = Utils.merge({
        canvasDelta: [0,0]
        worldTranslation: [0,0]
        canvasStartPoint: null
        canvasEndPoint: null
        worldStartPoint: null
        worldEndPoint: null
        isOnCanvas: true
      }, options)

      @[k] = v for k,v of options

      if !@canvasEndPoint? && @canvasStartPoint? && @canvasDelta?
        @canvasEndPoint = gl.vec2.create()
        gl.vec2.add @canvasEndPoint, @canvasStartPoint, @canvasDelta

      if !@worldEndPoint? && @worldStartPoint? && @worldTranslation?
        @worldEndPoint = gl.vec2.create()
        gl.vec2.add @worldEndPoint, @worldStartPoint, @worldTranslation

    calculateWorldCoordinates: (projector) ->
      @worldStartPoint = projector.unproject(@canvasStartPoint)
      @worldEndPoint = projector.unproject(@canvasEndPoint)
      @worldTranslation = gl.vec2.create()
      gl.vec2.subtract @worldTranslation, @worldEndPoint, @worldStartPoint

