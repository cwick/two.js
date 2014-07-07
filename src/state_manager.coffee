`import TwoObject from "./object"`

StateManager = TwoObject.extend
  initialize: ->
    @game = null
    @_states = {}

  register: (name, State) ->
    @_states[name] = State

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

  step: (increment) ->
    return unless @currentState
    @currentState.step(increment) if @currentState.__isReady__

`export default StateManager`

