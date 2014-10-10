`import TwoObject from "./object"`
`import Vector2d from "./vector2d"`
`import Rectangle from "./rectangle"`
`import Property from "./property"`

BoundingBox = Rectangle.extend
  fromSprite: (sprite) ->
    @width = sprite.width
    @height = sprite.height
    @y = (sprite.anchorPoint[1] - 0.5) * @height
    @x = -(sprite.anchorPoint[0] - 0.5) * @width

ArcadePhysicsBody = TwoObject.extend
  initialize: ->
    @userData = null
    @velocity = new Vector2d()
    @acceleration = new Vector2d()
    @position = new Vector2d()
    @_centerOfMass = new Vector2d()
    @boundingBox = new BoundingBox()
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

  centerOfMass: Property readonly: true

  position: Property
    set: (value) -> @_position = new Vector2d(value)

  velocity: Property
    set: (value) -> @_velocity = new Vector2d(value)

  maxVelocity: Property
    set: (value) -> @_maxVelocity = new Vector2d(value)

  drag: Property
    set: (value) -> @_drag = new Vector2d(value)

  postUpdate: ->
  preUpdate: ->

  _preUpdate: ->
    @updateCenterOfMassFromPosition()
    @resetTouches()
    @preUpdate()

  _postUpdate: ->
    @updatePositionFromCenterOfMass()
    @postUpdate()

  doWorldBoundsCollision: (worldBounds) ->
    return unless @collideWorldBounds
    return if worldBounds.width == 0 || worldBounds.height == 0

    halfWidth = @boundingBox.width/2
    halfHeight = @boundingBox.height/2

    min_x = @_centerOfMass[0] - halfWidth
    max_x = @_centerOfMass[0] + halfWidth
    min_y = @_centerOfMass[1] - halfHeight
    max_y = @_centerOfMass[1] + halfHeight

    bottom = worldBounds.y
    top = worldBounds.y + worldBounds.height
    left = worldBounds.x
    right = worldBounds.x + worldBounds.width

    if min_y <= bottom
      @_velocity[1] = @acceleration[1] = 0
      @_centerOfMass[1] = bottom + halfHeight
      @touching.down = true

    if max_y >= top
      @_velocity[1] = @acceleration[1] = 0
      @_centerOfMass[1] = top - halfHeight
      @touching.up = true

    if min_x <= left
      @_velocity[0] = @acceleration[0] = 0
      @_centerOfMass[0] = left + halfWidth
      @touching.left = true

    if max_x >= right
      @_velocity[0] = @acceleration[0] = 0
      @_centerOfMass[0] = right - halfWidth
      @touching.right = true

  updateCenterOfMassFromPosition: ->
    @_centerOfMass[0] = @_position[0] + @boundingBox.x
    @_centerOfMass[1] = @_position[1] + @boundingBox.y

  updatePositionFromCenterOfMass: ->
    @_position[0] = @_centerOfMass[0] - @boundingBox.x
    @_position[1] = @_centerOfMass[1] - @boundingBox.y

  applyGravity: (deltaSeconds, gravity) ->
    @_velocity[0] += gravity[0]*deltaSeconds
    @_velocity[1] += gravity[1]*deltaSeconds

  updateVelocity: (deltaSeconds) ->
    @applyAcceleration(deltaSeconds)
    @applyXDrag(deltaSeconds)
    @applyYDrag(deltaSeconds)
    @limitVelocity()

  updatePosition: (deltaSeconds) ->
    @_centerOfMass[0] += @_velocity[0]*deltaSeconds
    @_centerOfMass[1] += @_velocity[1]*deltaSeconds

  applyAcceleration: (deltaSeconds) ->
    @_velocity[0] += @acceleration[0]*deltaSeconds
    @_velocity[1] += @acceleration[1]*deltaSeconds

  applyXDrag: (deltaSeconds) ->
    if @acceleration[0] == 0
      if @_velocity[0] > 0
        @_velocity[0] -= @_drag[0]*deltaSeconds
        @_velocity[0] = 0 if @_velocity[0] < 0
      else if @_velocity[0] < 0
        @_velocity[0] += @_drag[0]*deltaSeconds
        @_velocity[0] = 0 if @_velocity[0] > 0

  applyYDrag: (deltaSeconds) ->
    if @acceleration[1] == 0
      if @_velocity[1] > 0
        @_velocity[1] -= @_drag[1]*deltaSeconds
        @_velocity[1] = 0 if @_velocity[1] < 0
      else if @_velocity[1] < 0
        @_velocity[1] += @_drag[1]*deltaSeconds
        @_velocity[1] = 0 if @_velocity[1] > 0

  limitVelocity: ->
    if @_velocity[0] > @_maxVelocity[0]
      @_velocity[0] = @_maxVelocity[0]
    else if @_velocity[0] < -@_maxVelocity[0]
      @_velocity[0] = -@_maxVelocity[0]

    if @_velocity[1] > @_maxVelocity[1]
      @_velocity[1] = @_maxVelocity[1]
    else if @_velocity[1] < -@_maxVelocity[1]
      @_velocity[1] = -@_maxVelocity[1]

  resetTouches: ->
    t = @touching
    t.up = t.down = t.left = t.right = false

ArcadePhysicsBody.STATIC = 0
ArcadePhysicsBody.DYNAMIC = 1

`export default ArcadePhysicsBody`
