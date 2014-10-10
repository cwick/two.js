`import TwoObject from "./object"`
`import Rectangle from "./rectangle"`
`import Vector2d from "./vector2d"`
`import Property from "./property"`

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
    body.world = @
    @isActive = true

  remove: (body) ->
    idx = @bodies.indexOf body
    if idx != -1
      @bodies.splice(idx, 1)
      body.world = null

  tick: (deltaSeconds) ->
    return unless @isActive
    @_runSimulation(deltaSeconds)
    @updateCallback(@bodies)

  _runSimulation: (deltaSeconds) ->
    for body in @bodies when body.enabled
      body.tick(deltaSeconds)

    return

`export default ArcadePhysicsWorld`

