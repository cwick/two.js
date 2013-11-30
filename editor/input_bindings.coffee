define ->
  class InputBindings
    constructor: (@signals) ->
      @_mouseWheelBindings = []
      @_keyBindings = {}

    addMouseWheelBinding: (binding) ->
      @_mouseWheelBindings.push binding

    addKeyBinding: (binding) ->
      bindingList = @_keyBindings[binding.keyCode] ?= []
      bindingList.push binding

    onMouseWheelMoved: (e) ->
      binding.call(@, e) for binding in @_mouseWheelBindings

    onKeyDown: (e) ->
      for binding in @_findKeyBindings(e.keyCode)
        binding.onKeyDown?.call @, e

    onKeyUp: (e) ->
      for binding in @_findKeyBindings(e.keyCode)
        binding.onKeyUp?.call @, e

    _findKeyBindings: (keyCode) ->
      @_keyBindings[keyCode] || []
