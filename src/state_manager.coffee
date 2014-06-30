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

    @_preloadState(@currentState).then =>
      setTimeout (=> @currentState.enter()), 0

  step: (increment) ->
    @currentState?.step?(increment)

  # Returns a promise that resolves when all assets loaded by the state's
  # 'preload' function have finished loading
  _preloadState: (state) ->
    i = @game.loader.pending.length
    state.preload()
    promises = @game.loader.pending.slice(i)
    Promise.all promises

`export default StateManager`

