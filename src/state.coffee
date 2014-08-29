`import TwoObject from "./object"`

State = TwoObject.extend
  initialize: ->
    @__isReady__ = true

  # Override these in derived states
  preload: ->
  enter: ->
  step: ->
  beforeRender: ->

  # Returns a promise that resolves when all assets loaded by the state's
  # 'preload' function have finished loading
  __preload__: ->
    @__isReady__ = false
    i = @game.loader.pending.length
    @preload()
    promises = @game.loader.pending.slice(i)
    Promise.all(promises).then => @__isReady__ = true

`export default State`
