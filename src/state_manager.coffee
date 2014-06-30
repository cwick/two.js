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
      setTimeout (=> @currentState.enter()), 0

  step: (increment) ->
    return unless @currentState
    @currentState.step(increment) if @currentState.__isReady__

`export default StateManager`

