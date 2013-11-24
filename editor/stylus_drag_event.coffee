define ["gl-matrix", "two/utils"], (gl, Utils) ->
  class StylusDragEvent
    constructor: (options={}) ->
      options = Utils.merge({
        canvasTranslation: [0,0]
        worldTranslation: [0,0]
        canvasStartPoint: null
        canvasEndPoint: null
        worldStartPoint: null
        worldEndPoint: null
        isOnCanvas: true
      }, options)

      @[k] = v for k,v of options

      if !@canvasEndPoint? && @canvasStartPoint? && @canvasTranslation?
        @canvasEndPoint = gl.vec2.create()
        gl.vec2.add @canvasEndPoint, @canvasStartPoint, @canvasTranslation

      if !@worldEndPoint? && @worldStartPoint? && @worldTranslation?
        @worldEndPoint = gl.vec2.create()
        gl.vec2.add @worldEndPoint, @worldStartPoint, @worldTranslation

    calculateWorldCoordinates: (projector) ->
      @worldStartPoint = projector.unproject(@canvasStartPoint)
      @worldEndPoint = projector.unproject(@canvasEndPoint)
      @_calculateWorldTranslation()

    setWorldEndPoint: (point) ->
      @worldEndPoint = gl.vec2.clone(point)
      @_calculateWorldTranslation()

    _calculateWorldTranslation: ->
      @worldTranslation = gl.vec2.create()
      gl.vec2.subtract @worldTranslation, @worldEndPoint, @worldStartPoint
