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
      body.position[0] -= body.boundingBox.x
      body.position[1] -= body.boundingBox.y
      @_resetTouches body
      @_updateBody body, time
      @_collideWorldBounds body
      body.position[0] += body.boundingBox.x
      body.position[1] += body.boundingBox.y

    return

  _resetTouches: (body) ->
    t = body.touching
    t.up = t.down = t.left = t.right = false

  _updateBody: (body, time) ->
    position = body.position
    velocity = body.velocity
    maxVelocity = body.maxVelocity
    acceleration = body.acceleration
    drag = body.drag
    dragVector = body.dragVector

    # Apply acceleration
    velocity[0] += acceleration[0]*time
    velocity[1] += acceleration[1]*time

    # Apply gravity
    velocity[0] += @gravity[0]*time
    velocity[1] += @gravity[1]*time

    # Enforce max velocity
    if velocity[0] > maxVelocity[0]
      velocity[0] = maxVelocity[0]
    else if velocity[0] < -maxVelocity[0]
      velocity[0] = -maxVelocity[0]

    if velocity[1] > maxVelocity[1]
      velocity[1] = maxVelocity[1]
    else if velocity[1] < -maxVelocity[1]
      velocity[1] = -maxVelocity[1]

    # Apply X drag
    if acceleration[0] == 0
      if velocity[0] > 0
        velocity[0] -= drag[0]*time
        velocity[0] = 0 if velocity[0] < 0
      else if velocity[0] < 0
        velocity[0] += drag[0]*time
        velocity[0] = 0 if velocity[0] > 0

    # Apply Y drag
    if acceleration[1] == 0
      if velocity[1] > 0
        velocity[1] -= drag[1]*time
        velocity[1] = 0 if velocity[1] < 0
      else if velocity[1] < 0
        velocity[1] += drag[1]*time
        velocity[1] = 0 if velocity[1] > 0

    # Update position
    position[0] += velocity[0]*time
    position[1] += velocity[1]*time

  _collideWorldBounds: (body) ->
    return unless body.collideWorldBounds
    return if @bounds.width == 0 || @bounds.height == 0

    position = body.position
    boundingBox = body.boundingBox
    halfWidth = boundingBox.width/2
    halfHeight = boundingBox.height/2

    min_x = body.position[0] - halfWidth
    max_x = body.position[0] + halfWidth
    min_y = body.position[1] - halfHeight
    max_y = body.position[1] + halfHeight

    bottom = @bounds.y
    top = @bounds.y + @bounds.height
    left = @bounds.x
    right = @bounds.x + @bounds.width

    if min_y <= bottom
      body.velocity[1] = body.acceleration[1] = 0
      body.position[1] = bottom + halfHeight
      body.touching.down = true

    if max_y >= top
      body.velocity[1] = body.acceleration[1] = 0
      body.position[1] = top - halfHeight
      body.touching.up = true

    if min_x <= left
      body.velocity[0] = body.acceleration[0] = 0
      body.position[0] = left + halfWidth
      body.touching.left = true

    if max_x >= right
      body.velocity[0] = body.acceleration[0] = 0
      body.position[0] = right - halfWidth
      body.touching.right = true

`export default ArcadePhysicsWorld`

