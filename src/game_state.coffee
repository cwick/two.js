`import TwoObject from "./object"`

GameState = TwoObject.extend
  initialize: ->
    @__isReady__ = true

  # Override these in derived states
  stateWillPreloadAssets: ->
  stateDidEnter: ->
  stateWillExit: ->
  stateWillTick: ->
  sceneWillRender: ->

  # Returns a promise that resolves when all preloadable assets have finished loading
  __preload__: ->
    @__isReady__ = false
    i = @game.loader.pending.length
    @stateWillPreloadAssets()
    promises = @game.loader.pending.slice(i)
    Promise.all(promises).then => @__isReady__ = true

`export default GameState`
