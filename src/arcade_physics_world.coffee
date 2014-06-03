`import TwoObject from "./object"`
`import Rectangle from "./rectangle"`
`import Vector2d from "./vector2d"`

ArcadePhysicsWorld = TwoObject.extend
  initialize: ->
    @bodies = []
    @bounds = new Rectangle()
    @gravity = new Vector2d()
    @updateCallback = ->
    @isActive = false

  add: (body) ->
    @bodies.push body
    @isActive = true

  step: (time) ->
    return unless @isActive
    @_runSimulation(time)
    @updateCallback(@bodies)

  _runSimulation: (time) ->
    for body in @bodies
      body.preUpdate()
      body.applyGravity(time, @gravity)
      body.updateVelocity(time)
      body.updatePosition(time)
      body.doWorldBoundsCollision(@bounds)
      body.postUpdate()

    return

`export default ArcadePhysicsWorld`

