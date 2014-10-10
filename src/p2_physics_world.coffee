`import TwoObject from "./object"`
`import Property from "./property"`
`module p2 from "./lib/p2"`

P2PhysicsWorld = TwoObject.extend
  initialize: ->
    @p2World = new p2.World()
    @isActive = false
    @updateCallback = ->

  add: (body) ->
    @p2World.addBody body
    @isActive = true

  tick: (deltaSeconds) ->
    return unless @isActive
    if @p2World.bodies.length > 0
      @p2World.step deltaSeconds
      @updateCallback(@p2World.bodies)

`export default P2PhysicsWorld`
