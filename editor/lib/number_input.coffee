define ["jquery", "./control", "../key_codes"], ($, Control, KeyCodes) ->
  class NumberInput extends Control
    constructor: ->
      super $("<input/>", type: "number")

      @$domElement.focus => @_onFocus()
      @$domElement.keydown (e) => @_onKeydown(e)
      @$domElement.change => @_onChange()

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

