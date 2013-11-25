define ["jquery", "./control", "../key_codes"], ($, Control, KeyCodes) ->
  class NumberInput extends Control
    constructor: (options={}) ->
      super $("<input/>", type: "number")

      @$domElement.focus => @_onFocus()
      @$domElement.keydown (e) => @_onKeydown(e)

      if options.digits?
        @$domElement.addClass "digit-#{options.digits}"
      if options.value?
        @setValue options.value

      @_decimalPlaces = options.decimalPlaces

    setValue: (v) ->
      if @_decimalPlaces?
        v = v.toFixed(@_decimalPlaces)

      @$domElement.val v

    getValue: ->
      parseFloat @$domElement.val()

    _onFocus: ->
      window.setTimeout (=> @$domElement.select()), 0

    _onKeydown: (e) ->
      @blur() if e.keyCode is KeyCodes.ENTER

