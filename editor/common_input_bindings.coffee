define ["./input_bindings", "./key_codes"], (InputBindings, KeyCodes) ->
  class CommonInputBindings extends InputBindings
    @QUICK_GRAB: ->
      @signals.quickToolSelected.dispatch "grab"

    @CLEAR_QUICK_TOOL: ->
      @signals.quickToolDeselected.dispatch()

    @ZOOM: (e) ->
      @signals.toolApplied.dispatch("zoom",
       canvasPoint: e.canvasPoint
       amount: e.amount*0.006)

    constructor: ->
      super

      @addMouseWheelBinding CommonInputBindings.ZOOM
      @addKeyBinding
        keyCode: KeyCodes.SHIFT
        onKeyDown: CommonInputBindings.QUICK_GRAB
        onKeyUp: CommonInputBindings.CLEAR_QUICK_TOOL
