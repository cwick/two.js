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
    @collideWorldBounds = true

  add: (body) ->
    @bodies.push body
    @isActive = true

  remove: (body) ->
    idx = @bodies.indexOf body
    if idx != -1
      @bodies.splice(idx, 1)

  step: (time) ->
    return unless @isActive
    @_runSimulation(time)
    @updateCallback(@bodies)

  _runSimulation: (time) ->
    for body in @bodies
      body._preUpdate()
      body.applyGravity(time, @gravity)
      body.updateVelocity(time)
      body.updatePosition(time)
      body.doWorldBoundsCollision(@bounds) if @collideWorldBounds
      body._postUpdate()

    return

`export default ArcadePhysicsWorld`

