`import TwoObject from "./object"`

StateManager = TwoObject.extend
  initialize: ->
    @game = null
    @_states = {}

  register: (name, GameState) ->
    @_states[name] = GameState

  transitionTo: (name) ->
    GameState = @_states[name]
    return false unless GameState?

    @currentState = new GameState()
    @currentState.game = @game
    @currentState.__preload__().then =>
      # The browser will swallow all exceptions thrown from this callback
      # so we have to capture and print the error ourself
      try
        @currentState.stateWillEnter()
      catch error
        console.error error.stack

    true

  sceneWillRender: ->
    @_callStateMethod "sceneWillRender"

  tick: (deltaSeconds) ->
    @_callStateMethod "stateWillTick", deltaSeconds

  _callStateMethod: (func) ->
    return unless @currentState

    if @currentState.__isReady__
      args = Array.prototype.slice.call(arguments, 1)
      @currentState[func].apply @currentState, args

`export default StateManager`

