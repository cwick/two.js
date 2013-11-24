define ["gl-matrix",
        "jquery",
        "./key_codes",
        "./mouse_buttons",
        "editor/stylus_drag_event",
        "jquery.mousewheel"], \
       (gl, $, KeyCodes, MouseButtons, StylusDragEvent) ->

  class EditorInput
    constructor: (@signals, @canvas) ->
      $(document).on "mousewheel keydown keyup mousedown mouseup mousemove", => @_onUserInput.apply @, arguments
      @_body = $("body")[0]

      @signals.stylusTouched.add @_onStylusTouched, @
      @signals.stylusReleased.add @_onStylusReleased, @

    _onUserInput: (e) ->
      handled = @["_on#{e.type.charAt(0).toUpperCase() + e.type.slice(1)}"].apply @, arguments
      if handled
        e.preventDefault()
        e.stopPropagation()

    _onMousewheel: (e, delta, deltaX, deltaY) ->
      return unless e.target == @canvas && deltaY != 0

      @signals.zoomLevelChanged.dispatch(deltaY*0.006)
      true

    _onKeydown: (e) ->
      return unless e.target == @_body

      if e.keyCode == KeyCodes.SHIFT
        @signals.grabToolSelected.dispatch()
        return true

    _onKeyup: (e) ->
      if e.keyCode == KeyCodes.SHIFT
        @signals.grabToolDeselected.dispatch()

      return e.target == @_body

    _onMousedown: (e) ->
      return unless e.target == @canvas && e.which == MouseButtons.LEFT

      @signals.stylusTouched.dispatch
        canvasPoint: [e.offsetX, e.offsetY]
        pagePoint: [e.pageX, e.pageY]

      return true

    _onMouseup: (e) ->
      return unless @_isStylusTouching() && e.which == MouseButtons.LEFT

      @signals.stylusReleased.dispatch @_createStylusDragEvent(e)

      return e.target == @canvas

    _onMousemove: (e) ->
      if @_isStylusTouching()
        @_dispatchStylusDragged(e)
      else if e.target == @canvas
        @_dispatchStylusMoved(e)

      return e.target == @canvas

    _dispatchStylusDragged: (e) ->
      @signals.stylusDragged.dispatch @_createStylusDragEvent(e)

    _dispatchStylusMoved: (e) ->
      @signals.stylusMoved.dispatch(canvasPoint: [e.offsetX, e.offsetY])

    _createStylusDragEvent: (e) ->
      new StylusDragEvent
        canvasStartPoint: gl.vec2.clone(@_stylusCanvasTouchPoint)
        canvasTranslation: @_getStylusDelta(e.pageX, e.pageY)
        isOnCanvas: e.target == @canvas

    _getStylusDelta: (x,y) ->
      delta = gl.vec2.create()

      if @_isStylusTouching()
        gl.vec2.subtract(delta, [x,y], @_stylusPageTouchPoint)

      delta

    _isStylusTouching: ->
      @_stylusCanvasTouchPoint?

    _onStylusTouched: (options) ->
      @_stylusPageTouchPoint = options.pagePoint
      @_stylusCanvasTouchPoint = options.canvasPoint

    _onStylusReleased: ->
      @_stylusPageTouchPoint = @_stylusCanvasTouchPoint = null

