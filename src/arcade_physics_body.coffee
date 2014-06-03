`import TwoObject from "./object"`
`import Vector2d from "../vector2d"`
`import Rectangle from "../rectangle"`

ArcadePhysicsBody = TwoObject.extend
  initialize: ->
    @userData = null
    @velocity = new Vector2d()
    @acceleration = new Vector2d()
    @position = new Vector2d()
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

  preUpdate: ->
    @unsetOrigin()
    @resetTouches()

  postUpdate: ->
    @setOrigin()

  doWorldBoundsCollision: (worldBounds) ->
    return unless @collideWorldBounds
    return if worldBounds.width == 0 || worldBounds.height == 0

    halfWidth = @boundingBox.width/2
    halfHeight = @boundingBox.height/2

    min_x = @position[0] - halfWidth
    max_x = @position[0] + halfWidth
    min_y = @position[1] - halfHeight
    max_y = @position[1] + halfHeight

    bottom = worldBounds.y
    top = worldBounds.y + worldBounds.height
    left = worldBounds.x
    right = worldBounds.x + worldBounds.width

    if min_y <= bottom
      @velocity[1] = @acceleration[1] = 0
      @position[1] = bottom + halfHeight
      @touching.down = true

    if max_y >= top
      @velocity[1] = @acceleration[1] = 0
      @position[1] = top - halfHeight
      @touching.up = true

    if min_x <= left
      @velocity[0] = @acceleration[0] = 0
      @position[0] = left + halfWidth
      @touching.left = true

    if max_x >= right
      @velocity[0] = @acceleration[0] = 0
      @position[0] = right - halfWidth
      @touching.right = true

  unsetOrigin: ->
    @position[0] -= @boundingBox.x
    @position[1] -= @boundingBox.y

  setOrigin: ->
    @position[0] += @boundingBox.x
    @position[1] += @boundingBox.y

  applyGravity: (time, gravity) ->
    @velocity[0] += gravity[0]*time
    @velocity[1] += gravity[1]*time

  updateVelocity: (time) ->
    @applyAcceleration(time)
    @applyXDrag(time)
    @applyYDrag(time)
    @limitVelocity()

  updatePosition: (time) ->
    @position[0] += @velocity[0]*time
    @position[1] += @velocity[1]*time

  applyAcceleration: (time) ->
    @velocity[0] += @acceleration[0]*time
    @velocity[1] += @acceleration[1]*time

  applyXDrag: (time) ->
    if @acceleration[0] == 0
      if @velocity[0] > 0
        @velocity[0] -= @drag[0]*time
        @velocity[0] = 0 if @velocity[0] < 0
      else if @velocity[0] < 0
        @velocity[0] += @drag[0]*time
        @velocity[0] = 0 if @velocity[0] > 0

  applyYDrag: (time) ->
    if @acceleration[1] == 0
      if @velocity[1] > 0
        @velocity[1] -= @drag[1]*time
        @velocity[1] = 0 if @velocity[1] < 0
      else if @velocity[1] < 0
        @velocity[1] += @drag[1]*time
        @velocity[1] = 0 if @velocity[1] > 0

  limitVelocity: ->
    if @velocity[0] > @maxVelocity[0]
      @velocity[0] = @maxVelocity[0]
    else if @velocity[0] < -@maxVelocity[0]
      @velocity[0] = -@maxVelocity[0]

    if @velocity[1] > @maxVelocity[1]
      @velocity[1] = @maxVelocity[1]
    else if @velocity[1] < -@maxVelocity[1]
      @velocity[1] = -@maxVelocity[1]

  resetTouches: ->
    t = @touching
    t.up = t.down = t.left = t.right = false

ArcadePhysicsBody.STATIC = 0
ArcadePhysicsBody.DYNAMIC = 1

`export default ArcadePhysicsBody`
