`import TwoObject from "./object"`
`import Vector2d from "./vector2d"`
`import Rectangle from "./rectangle"`
`import Property from "./property"`

BoundingBox = Rectangle.extend
  fromSprite: (sprite) ->
    @width = sprite.width
    @height = sprite.height
    @y = (sprite.anchorPoint[1] - 0.5) * @height
    @x = (sprite.anchorPoint[0] - 0.5) * @width

ArcadePhysicsBody = TwoObject.extend
  initialize: ->
    @userData = null
    @velocity = new Vector2d()
    @acceleration = new Vector2d()
    @position = new Vector2d()
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

  position: Property
    set: (value) -> @_position = new Vector2d(value)

  velocity: Property
    set: (value) -> @_velocity = new Vector2d(value)

  postUpdate: ->
  preUpdate: ->

  _preUpdate: ->
    @unsetOrigin()
    @resetTouches()
    @preUpdate()

  _postUpdate: ->
    @setOrigin()
    @postUpdate()

  doWorldBoundsCollision: (worldBounds) ->
    return unless @collideWorldBounds
    return if worldBounds.width == 0 || worldBounds.height == 0

    halfWidth = @boundingBox.width/2
    halfHeight = @boundingBox.height/2

    min_x = @_position[0] - halfWidth
    max_x = @_position[0] + halfWidth
    min_y = @_position[1] - halfHeight
    max_y = @_position[1] + halfHeight

    bottom = worldBounds.y
    top = worldBounds.y + worldBounds.height
    left = worldBounds.x
    right = worldBounds.x + worldBounds.width

    if min_y <= bottom
      @_velocity[1] = @acceleration[1] = 0
      @_position[1] = bottom + halfHeight
      @touching.down = true

    if max_y >= top
      @_velocity[1] = @acceleration[1] = 0
      @_position[1] = top - halfHeight
      @touching.up = true

    if min_x <= left
      @_velocity[0] = @acceleration[0] = 0
      @_position[0] = left + halfWidth
      @touching.left = true

    if max_x >= right
      @_velocity[0] = @acceleration[0] = 0
      @_position[0] = right - halfWidth
      @touching.right = true

  unsetOrigin: ->
    @_position[0] -= @boundingBox.x
    @_position[1] -= @boundingBox.y

  setOrigin: ->
    @_position[0] += @boundingBox.x
    @_position[1] += @boundingBox.y

  applyGravity: (time, gravity) ->
    @_velocity[0] += gravity[0]*time
    @_velocity[1] += gravity[1]*time

  updateVelocity: (time) ->
    @applyAcceleration(time)
    @applyXDrag(time)
    @applyYDrag(time)
    @limitVelocity()

  updatePosition: (time) ->
    @_position[0] += @_velocity[0]*time
    @_position[1] += @_velocity[1]*time

  applyAcceleration: (time) ->
    @_velocity[0] += @acceleration[0]*time
    @_velocity[1] += @acceleration[1]*time

  applyXDrag: (time) ->
    if @acceleration[0] == 0
      if @_velocity[0] > 0
        @_velocity[0] -= @drag[0]*time
        @_velocity[0] = 0 if @_velocity[0] < 0
      else if @_velocity[0] < 0
        @_velocity[0] += @drag[0]*time
        @_velocity[0] = 0 if @_velocity[0] > 0

  applyYDrag: (time) ->
    if @acceleration[1] == 0
      if @_velocity[1] > 0
        @_velocity[1] -= @drag[1]*time
        @_velocity[1] = 0 if @_velocity[1] < 0
      else if @_velocity[1] < 0
        @_velocity[1] += @drag[1]*time
        @_velocity[1] = 0 if @_velocity[1] > 0

  limitVelocity: ->
    if @_velocity[0] > @maxVelocity[0]
      @_velocity[0] = @maxVelocity[0]
    else if @_velocity[0] < -@maxVelocity[0]
      @_velocity[0] = -@maxVelocity[0]

    if @_velocity[1] > @maxVelocity[1]
      @_velocity[1] = @maxVelocity[1]
    else if @_velocity[1] < -@maxVelocity[1]
      @_velocity[1] = -@maxVelocity[1]

  resetTouches: ->
    t = @touching
    t.up = t.down = t.left = t.right = false

ArcadePhysicsBody.STATIC = 0
ArcadePhysicsBody.DYNAMIC = 1

`export default ArcadePhysicsBody`
