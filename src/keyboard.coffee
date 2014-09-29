class Keyboard
  constructor: ->
    @_keyState = {}

  start: ->
    window.addEventListener('keydown', @_onKeyDown.bind @)
    window.addEventListener('keyup', @_onKeyUp.bind @)

  isKeyDown: (key) ->
    @_keyState[key] || false

  # TODO: make this work properly
  wasKeyPressed: (key) ->
    @_keyState[key] || false

  _onKeyDown: (e) ->
    @_keyState[e.keyCode] = true

  _onKeyUp: (e) ->
    @_keyState[e.keyCode] = false

`export default Keyboard`
