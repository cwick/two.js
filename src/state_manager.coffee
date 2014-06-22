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
    state = new State()
    state.preload(@game)
    state.enter(@game)

`export default StateManager`

