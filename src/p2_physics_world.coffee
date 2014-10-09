`import TwoObject from "./object"`
`import Property from "./property"`
`module p2 from "./lib/p2"`

P2PhysicsWorld = TwoObject.extend
  initialize: ->
    @p2 = new p2.World()
    @isActive = false
    @updateCallback = ->

  add: (body) ->
    @p2.addBody body
    @isActive = true

  tick: (deltaSeconds) ->
    return unless @isActive
    if @p2.bodies.length > 0
      @p2.step deltaSeconds
      @updateCallback(@p2.bodies)

`export default P2PhysicsWorld`
