`import TwoObject from "./object"`
`import Rectangle from "./rectangle"`
`import Vector2d from "./vector2d"`
`import ArcadePhysicsBody from "./arcade_physics_body"`

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
      # Motion
      @_updateBodyMotion body, time

      # Collision response
      body.resetTouching()
      body.updateBoundingBoxLimits()

      @_collideWorldBounds body
      @_collideOtherBodies body

    return

  _updateBodyMotion: (body, time) ->
    return unless body.type is ArcadePhysicsBody.DYNAMIC
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

  _collideOtherBodies: (body) ->
    return unless body.type == ArcadePhysicsBody.DYNAMIC

    for otherBody in @bodies when otherBody isnt body and otherBody.type == ArcadePhysicsBody.STATIC
      @_collideDynamicVSStatic body, otherBody

    return

  _collideDynamicVSStatic: (body, obstacle) ->
    a = body.boundingBoxLimits
    b = obstacle.boundingBoxLimits

    penetration = { x: 0.0, y: 0.0 }

    left = b.minX - a.maxX
    right = a.minX - b.maxX
    top = a.minY - b.maxY
    bottom = b.minY - a.maxY

    # boxes don't intersect
    # return if left > 0 || right < 0 || top > 0 || bottom < 0
    return if top > 0 || bottom > 0 || left > 0 || right > 0


    # boxes intersect. work out the min translation on both x and y axes.
    # if Math.abs(left) < right
    #     minTranslation.x = left
    # else
    #     minTranslation.x = right

    if top > bottom
      penetration.y = -top
    else
      penetration.y = -bottom

    if right > left
      penetration.x = -right
    else
      penetration.x = -left

    vx = Math.abs(body.velocity[0])
    vy = Math.abs(body.velocity[1])

    pushY = if vx == vy then penetration.y < penetration.x else vy > vx || penetration.y == 0
    pushY = penetration.y < penetration.x

    # Push along Y axis to resolve collision
    if pushY
      body.velocity[1] = body.acceleration[1] = 0.0
      if top > bottom
        body.position[1] = b.maxY + body.boundingBox.y + body.boundingBox.height/2
        body.touching.down = true
      else
        body.position[1] = b.minY + body.boundingBox.y - body.boundingBox.height/2
        body.touching.up = true
    # Push along X axis to resolve collision
    else
      console.log penetration, body.velocity, "x"
      body.velocity[0] = body.acceleration[0] = 0.0
      if right > left
        body.position[0] = b.maxX + body.boundingBox.x + body.boundingBox.width/2
        body.touching.left = true
      else
        body.position[0] = b.minX + body.boundingBox.x - body.boundingBox.width/2
        body.touching.right = true

    body.updateBoundingBoxLimits()

  _collideWorldBounds: (body) ->
    return unless body.collideWorldBounds
    return if @bounds.width == 0 || @bounds.height == 0

    position = body.position
    boundingBox = body.boundingBox
    boundingBoxLimits = body.boundingBoxLimits
    halfWidth = boundingBox.width/2
    halfHeight = boundingBox.height/2

    bottom = @bounds.y
    top = @bounds.y + @bounds.height
    left = @bounds.x
    right = @bounds.x + @bounds.width

    if boundingBoxLimits.minY <= bottom
      body.velocity[1] = body.acceleration[1] = 0
      body.position[1] = bottom + halfHeight + boundingBox.y
      body.touching.down = true

    if boundingBoxLimits.maxY >= top
      body.velocity[1] = body.acceleration[1] = 0
      body.position[1] = top - halfHeight + boundingBox.y
      body.touching.up = true

    if boundingBoxLimits.minX <= left
      body.velocity[0] = body.acceleration[0] = 0
      body.position[0] = left + halfWidth - boundingBox.x
      body.touching.left = true

    if boundingBoxLimits.maxX >= right
      body.velocity[0] = body.acceleration[0] = 0
      body.position[0] = right - halfWidth - boundingBox.x
      body.touching.right = true

    body.updateBoundingBoxLimits()

`export default ArcadePhysicsWorld`

