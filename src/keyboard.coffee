class KeyState
  constructor: ->
    @isDown = false
    @wasPressed = false

class Keyboard
  constructor: (@game) ->
    @_keyStates = {}

  start: ->
    window.addEventListener('keydown', @_onKeyDown.bind @)
    window.addEventListener('keyup', @_onKeyUp.bind @)

  isKeyDown: (key) ->
    @_keyStates[key]?.isDown || false

  # TODO: make this work properly
  wasKeyPressed: (key) ->
    @_keyStates[key]?.wasPressed || false

  _onKeyDown: (e) ->
    state = @_keyStates[e.keyCode] ||= new KeyState()
    state.wasPressed = !state.isDown
    state.isDown = true

    @game.defer(1, (-> state.wasPressed = false))

  _onKeyUp: (e) ->
    state = @_keyStates[e.keyCode] ||= new KeyState()
    state.isDown = false

`export default Keyboard`
