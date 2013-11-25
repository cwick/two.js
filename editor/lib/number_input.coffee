define ["jquery", "./control", "../key_codes"], ($, Control, KeyCodes) ->
  class NumberInput extends Control
    constructor: (options={}) ->
      super $("<input/>", type: "number")

      @$domElement.focus => @_onFocus()
      @$domElement.keydown (e) => @_onKeydown(e)
      @$domElement.change => @_onChange()

      if options.digits?
        @$domElement.addClass "digit-#{options.digits}"

    setValue: (v) ->
      @$domElement.val v.toFixed(2)

    getValue: ->
      parseFloat @$domElement.val()

    _onFocus: ->
      window.setTimeout (=> @$domElement.select()), 0

    _onKeydown: (e) ->
      @blur() if e.keyCode is KeyCodes.ENTER

    _onChange: ->
      @blur()

