`import TwoObject from "./object"`
`import Vector2d from "./vector2d"`
`import Rectangle from "./rectangle"`
`import Property from "./property"`

ArcadePhysicsBody = TwoObject.extend
  initialize: ->
    @userData = null
    @velocity = new Vector2d()
    @acceleration = new Vector2d()
    @position = new Vector2d()
    @_centerOfMass = new Vector2d()
    @boundingBox = new Rectangle()
    @maxVelocity = new Vector2d([Number.MAX_VALUE, Number.MAX_VALUE])
    @drag = new Vector2d()
    @type = ArcadePhysicsBody.DYNAMIC
    @collideWorldBounds = true
    @touching =
      up: false
      down: false
      left: false
      right: false
    @enabled = true
    @delegate = null
    @world = null

  centerOfMass: Property readonly: true

  position: Property
    set: (value) -> @_position = new Vector2d(value)

  velocity: Property
    set: (value) -> @_velocity = new Vector2d(value)

  acceleration: Property
    set: (value) -> @_acceleration = new Vector2d(value)

  maxVelocity: Property
    set: (value) -> @_maxVelocity = new Vector2d(value)

  drag: Property
    set: (value) -> @_drag = new Vector2d(value)

  tick: (deltaSeconds) ->
    return unless @world

    @preUpdate()
    @applyGravity(deltaSeconds, @world.gravity)
    @updateVelocity(deltaSeconds)
    @applyVelocity(deltaSeconds)
    @doWorldBoundsCollision(@world.bounds)
    @postUpdate()

  preUpdate: ->
    @updateCenterOfMassFromPosition()
    @resetTouches()
    @delegate?.physicsBodyWillUpdate?()

  postUpdate: ->
    @updatePositionFromCenterOfMass()
    @delegate?.physicsBodyDidUpdate?()

  doWorldBoundsCollision: (worldBounds) ->
    return unless @world.collideWorldBounds && @collideWorldBounds
    return if worldBounds.width == 0 || worldBounds.height == 0

    halfWidth = @boundingBox.width/2
    halfHeight = @boundingBox.height/2

    min_x = @_centerOfMass.x - halfWidth
    max_x = @_centerOfMass.x + halfWidth
    min_y = @_centerOfMass.y - halfHeight
    max_y = @_centerOfMass.y + halfHeight

    bottom = worldBounds.y
    top = worldBounds.y + worldBounds.height
    left = worldBounds.x
    right = worldBounds.x + worldBounds.width

    if min_y <= bottom
      @_velocity.y = @acceleration.y = 0
      @_centerOfMass.y = bottom + halfHeight
      @touching.down = true

    if max_y >= top
      @_velocity.y = @acceleration.y = 0
      @_centerOfMass.y = top - halfHeight
      @touching.up = true

    if min_x <= left
      @_velocity.x = @acceleration.x = 0
      @_centerOfMass.x = left + halfWidth
      @touching.left = true

    if max_x >= right
      @_velocity.x = @acceleration.x = 0
      @_centerOfMass.x = right - halfWidth
      @touching.right = true

  updateCenterOfMassFromPosition: ->
    @_centerOfMass.x = @_position.x + @boundingBox.x
    @_centerOfMass.y = @_position.y + @boundingBox.y

  updatePositionFromCenterOfMass: ->
    @_position.x = @_centerOfMass.x - @boundingBox.x
    @_position.y = @_centerOfMass.y - @boundingBox.y

  applyGravity: (deltaSeconds, gravity) ->
    @_velocity.x += gravity.x*deltaSeconds
    @_velocity.y += gravity.y*deltaSeconds

  updateVelocity: (deltaSeconds) ->
    @applyAcceleration(deltaSeconds)
    @applyXDrag(deltaSeconds)
    @applyYDrag(deltaSeconds)
    @limitVelocity()

  applyVelocity: (deltaSeconds) ->
    @_centerOfMass.x += @_velocity.x*deltaSeconds
    @_centerOfMass.y += @_velocity.y*deltaSeconds

  applyAcceleration: (deltaSeconds) ->
    @_velocity.x += @acceleration.x*deltaSeconds
    @_velocity.y += @acceleration.y*deltaSeconds

  applyXDrag: (deltaSeconds) ->
    if @acceleration.x == 0
      if @_velocity.x > 0
        @_velocity.x -= @_drag.x*deltaSeconds
        @_velocity.x = 0 if @_velocity.x < 0
      else if @_velocity.x < 0
        @_velocity.x += @_drag.x*deltaSeconds
        @_velocity.x = 0 if @_velocity.x > 0

  applyYDrag: (deltaSeconds) ->
    if @acceleration.y == 0
      if @_velocity.y > 0
        @_velocity.y -= @_drag.y*deltaSeconds
        @_velocity.y = 0 if @_velocity.y < 0
      else if @_velocity.y < 0
        @_velocity.y += @_drag.y*deltaSeconds
        @_velocity.y = 0 if @_velocity.y > 0

  limitVelocity: ->
    if @_velocity.x > @_maxVelocity.x
      @_velocity.x = @_maxVelocity.x
    else if @_velocity.x < -@_maxVelocity.x
      @_velocity.x = -@_maxVelocity.x

    if @_velocity.y > @_maxVelocity.y
      @_velocity.y = @_maxVelocity.y
    else if @_velocity.y < -@_maxVelocity.y
      @_velocity.y = -@_maxVelocity.y

  resetTouches: ->
    t = @touching
    t.up = t.down = t.left = t.right = false

ArcadePhysicsBody.STATIC = 0
ArcadePhysicsBody.DYNAMIC = 1

`export default ArcadePhysicsBody`
