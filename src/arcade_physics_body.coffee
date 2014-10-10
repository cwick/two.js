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
      @velocity.y = @acceleration.y = 0
      @_centerOfMass.y = bottom + halfHeight
      @touching.down = true

    if max_y >= top
      @velocity.y = @acceleration.y = 0
      @_centerOfMass.y = top - halfHeight
      @touching.up = true

    if min_x <= left
      @velocity.x = @acceleration.x = 0
      @_centerOfMass.x = left + halfWidth
      @touching.left = true

    if max_x >= right
      @velocity.x = @acceleration.x = 0
      @_centerOfMass.x = right - halfWidth
      @touching.right = true

  updateCenterOfMassFromPosition: ->
    @_centerOfMass.x = @position.x + @boundingBox.x
    @_centerOfMass.y = @position.y + @boundingBox.y

  updatePositionFromCenterOfMass: ->
    @position.x = @_centerOfMass.x - @boundingBox.x
    @position.y = @_centerOfMass.y - @boundingBox.y

  applyGravity: (deltaSeconds, gravity) ->
    @velocity.x += gravity.x*deltaSeconds
    @velocity.y += gravity.y*deltaSeconds

  updateVelocity: (deltaSeconds) ->
    @applyAcceleration(deltaSeconds)
    @applyXDrag(deltaSeconds)
    @applyYDrag(deltaSeconds)
    @limitVelocity()

  applyVelocity: (deltaSeconds) ->
    @_centerOfMass.x += @velocity.x*deltaSeconds
    @_centerOfMass.y += @velocity.y*deltaSeconds

  applyAcceleration: (deltaSeconds) ->
    @velocity.x += @acceleration.x*deltaSeconds
    @velocity.y += @acceleration.y*deltaSeconds

  applyXDrag: (deltaSeconds) ->
    if @acceleration.x == 0
      if @velocity.x > 0
        @velocity.x -= @drag.x*deltaSeconds
        @velocity.x = 0 if @velocity.x < 0
      else if @velocity.x < 0
        @velocity.x += @drag.x*deltaSeconds
        @velocity.x = 0 if @velocity.x > 0

  applyYDrag: (deltaSeconds) ->
    if @acceleration.y == 0
      if @velocity.y > 0
        @velocity.y -= @drag.y*deltaSeconds
        @velocity.y = 0 if @velocity.y < 0
      else if @velocity.y < 0
        @velocity.y += @drag.y*deltaSeconds
        @velocity.y = 0 if @velocity.y > 0

  limitVelocity: ->
    if @velocity.x > @maxVelocity.x
      @velocity.x = @maxVelocity.x
    else if @velocity.x < -@maxVelocity.x
      @velocity.x = -@maxVelocity.x

    if @velocity.y > @maxVelocity.y
      @velocity.y = @maxVelocity.y
    else if @velocity.y < -@maxVelocity.y
      @velocity.y = -@maxVelocity.y

  resetTouches: ->
    t = @touching
    t.up = t.down = t.left = t.right = false

ArcadePhysicsBody.STATIC = 0
ArcadePhysicsBody.DYNAMIC = 1

`export default ArcadePhysicsBody`
