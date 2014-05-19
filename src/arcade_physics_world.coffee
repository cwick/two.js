`import TwoObject from "./object"`
`import Property from "./property"`
`import Rectangle from "./rectangle"`
`import Vector2d from "./vector2d"`

ArcadePhysicsWorld = TwoObject.extend
  initialize: ->
    @objects = []
    @bounds = new Rectangle()
    @gravity = new Vector2d()

  add: (object) ->
    @objects.push object

  step: (time) ->
    @_runSimulation(time)
    @_updateObjectTransforms()

  _runSimulation: (time) ->
    for object in @objects
      body = object.physics

      @_resetTouches body
      @_updateBody body, time
      @_collideWorldBounds body

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

    center_x = body.position[0] - boundingBox.x
    center_y = body.position[1] - boundingBox.y

    min_x = center_x - halfWidth
    max_x = center_x + halfWidth
    min_y = center_y - halfHeight
    max_y = center_y + halfHeight

    bottom = @bounds.y
    top = @bounds.y + @bounds.height
    left = @bounds.x
    right = @bounds.x + @bounds.width

    if min_y <= bottom
      body.velocity[1] = body.acceleration[1] = 0
      body.position[1] = bottom + halfHeight + boundingBox.y
      body.touching.down = true

    if max_y >= top
      body.velocity[1] = body.acceleration[1] = 0
      body.position[1] = top - halfHeight + boundingBox.y
      body.touching.up = true

    if min_x <= left
      body.velocity[0] = body.acceleration[0] = 0
      body.position[0] = left + halfWidth - boundingBox.x
      body.touching.left = true

    if max_x >= right
      body.velocity[0] = body.acceleration[0] = 0
      body.position[0] = right - halfWidth - boundingBox.x
      body.touching.right = true

  _updateObjectTransforms: ->
    for object in @objects
      transform = object.transform
      body = object.physics
      transform.position[0] = body.position[0]
      transform.position[1] = body.position[1]

    return

`export default ArcadePhysicsWorld`

