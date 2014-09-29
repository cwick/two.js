`import TwoObject from "./object"`
`import Property from "./property"`
`module p2 from "./lib/p2"`

P2PhysicsWorld = TwoObject.extend
  initialize: ->
    @world = new p2.World()
    @isActive = false
    @updateCallback = ->

  add: (body) ->
    @world.addBody body
    @isActive = true

  tick: (deltaSeconds) ->
    return unless @isActive
    if @world.bodies.length > 0
      @world.step deltaSeconds
      @updateCallback(@world.bodies)

`export default P2PhysicsWorld`
