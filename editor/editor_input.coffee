define ["jquery", "jquery.mousewheel"], ($) ->
  class EditorInput
    constructor: (@signals, @canvas) ->
      $(document).on "mousewheel", => @_onUserInput.apply @, arguments

    _onUserInput: (e) ->
      handled = @["_on#{e.type.charAt(0).toUpperCase() + e.type.slice(1)}"].apply @, arguments
      if handled
        e.preventDefault()
        e.stopPropagation()

    _onMousewheel: (e, delta, deltaX, deltaY) ->
      return unless e.target == @canvas && deltaY != 0

      @signals.zoomLevelChanged.dispatch(deltaY*0.006)
      true

