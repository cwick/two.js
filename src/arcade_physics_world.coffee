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

  tick: (deltaSeconds) ->
    return unless @isActive
    @_runSimulation(deltaSeconds)
    @updateCallback(@bodies)

  _runSimulation: (deltaSeconds) ->
    for body in @bodies when body.enabled
      body._preUpdate()
      body.applyGravity(deltaSeconds, @gravity)
      body.updateVelocity(deltaSeconds)
      body.updatePosition(deltaSeconds)
      body.doWorldBoundsCollision(@bounds) if @collideWorldBounds
      body._postUpdate()

    return

`export default ArcadePhysicsWorld`

