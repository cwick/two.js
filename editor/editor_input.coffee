define ["jquery", "two/utils", "./key_codes", "jquery.mousewheel"], ($, Utils, KeyCodes) ->
  class EditorInput
    constructor: (@signals, @canvas) ->
      $(document).on "mousewheel keydown keyup", => @_onUserInput.apply @, arguments
      @_body = $("body")[0]

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

