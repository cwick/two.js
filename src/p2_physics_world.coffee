`import TwoObject from "./object"`
`import Property from "./property"`
`module p2 from "../lib/p2"`

P2PhysicsWorld = TwoObject.extend
  initialize: ->
    @world = new p2.World()
    @_bodyMap = {}

  add: (object) ->
    body = object.physics
    @_bodyMap[body.id] = object
    @world.addBody body

  step: (increment) ->
    if @world.bodies.length > 0
      @world.step increment
      @_updateObjectTransforms()

  # Don't hard-code physics -> game ojbect update. See ArcadePhysicsWorld.
  _updateObjectTransforms: ->
    for body in @world.bodies
      object = @_bodyMap[body.id]
      transform = object.transform
      transform.position[0] = body.position[0]
      transform.position[1] = body.position[1]
      transform.rotation = body.angle

`export default P2PhysicsWorld`
