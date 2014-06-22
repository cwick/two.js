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

    @_preloadState(state, @game).then =>
      state.enter(@game)

  _preloadState: (state, game) ->
    i = game.loader.pending.length
    state.preload(game)
    promises = game.loader.pending.slice(i)
    Promise.all promises

`export default StateManager`

