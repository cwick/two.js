define ["gl-matrix",
        "jquery",
        "./key_codes",
        "./mouse_buttons",
        "editor/stylus_drag_event",
        "jquery.mousewheel"], \
       (gl, $, KeyCodes, MouseButtons, StylusDragEvent) ->

  class EditorInput
    @capturingCanvas = null

    constructor: (@signals, @canvas) ->
      $(document).on "mousewheel keydown keyup mousedown mouseup mousemove", => @_onUserInput.apply @, arguments
      $(@canvas).mouseenter => @canvas.focus()

      @signals.stylusTouched.add @_onStylusTouched, @
      @signals.stylusReleased.add @_onStylusReleased, @

    _onUserInput: (e) ->
      shouldPreventDefault = @["_on#{e.type.charAt(0).toUpperCase() + e.type.slice(1)}"].apply @, arguments

      if shouldPreventDefault
        e.preventDefault()
        e.stopPropagation()

    _onMousewheel: (e, delta, deltaX, deltaY) ->
      return false if deltaY == 0
      return false unless @_shouldHandleInput(e)

      @signals.toolActivated.dispatch("zoom", @_getStylusPosition(e), deltaY*0.006)
      return true

    _onKeydown: (e) ->
      return false unless @_shouldHandleInput(e)

      if e.keyCode == KeyCodes.SHIFT
        @signals.quickToolSelected.dispatch "grab"

      return false

    _onKeyup: (e) ->
      if e.keyCode == KeyCodes.SHIFT
        @signals.quickToolDeselected.dispatch()

      return false

    _onMousedown: (e) ->
      return false unless e.which == MouseButtons.LEFT
      return unless @_shouldHandleInput(e)

      @signals.stylusTouched.dispatch @_getStylusPosition(e)

      return false

    _onMouseup: (e) ->
      return false unless @_isStylusTouching() && e.which == MouseButtons.LEFT

      @signals.stylusReleased.dispatch @_createStylusDragEvent(e)
      return false

    _onMousemove: (e) ->
      return unless @_shouldHandleInput(e)

      if @_isStylusTouching()
        @_dispatchStylusDragged(e)
      else
        @_dispatchStylusMoved(e)

      return false

    _shouldHandleInput: (e) ->
      EditorInput.capturingCanvas == @canvas || (!EditorInput.capturingCanvas? && e.target == @canvas)

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

    _getStylusPosition: (e) ->
      canvasPoint: [e.offsetX, e.offsetY]
      pagePoint: [e.pageX, e.pageY]

    _isStylusTouching: ->
      @_stylusCanvasTouchPoint?

    _onStylusTouched: (options) ->
      @_stylusPageTouchPoint = options.pagePoint
      @_stylusCanvasTouchPoint = options.canvasPoint
      EditorInput.capturingCanvas = @canvas

    _onStylusReleased: ->
      @_stylusPageTouchPoint = @_stylusCanvasTouchPoint = null
      EditorInput.capturingCanvas = null

