`import TwoObject from "./object"`

StateManager = TwoObject.extend
  initialize: ->
    @game = null
    @_states = {}

  register: (name, State) ->
    @_states[name] = State

  isStateRegistered: (name) ->
    @_states[name]?

  transitionTo: (name) ->
    State = @_states[name]
    throw new Error("StateManager#transitionTo -- Invalid state '#{name}'") unless State?
    @currentState = new State()
    @currentState.game = @game
    @currentState.__preload__().then =>
      # The browser will swallow all exceptions thrown from this callback
      # so we have to capture and print the error ourself
      try
        @currentState.enter()
      catch error
        console.error error.stack

  beforeRender: ->
    @_callState "beforeRender"

  tick: (deltaSeconds) ->
    @_callState "tick", deltaSeconds

  _callState: (func) ->
    return unless @currentState
    args = Array.prototype.slice.call(arguments, 1)
    @currentState[func].apply @currentState, args if @currentState.__isReady__

`export default StateManager`

