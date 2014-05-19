`import TwoObject from "./object"`
`import Property from "./property"`
`import Rectangle from "./rectangle"`

ArcadePhysicsWorld = TwoObject.extend
  initialize: ->
    @objects = []
    @bounds = new Rectangle()

  add: (object) ->
    @objects.push object

  step: (increment) ->
    @_runSimulation(increment)
    @_updateObjectTransforms()

  _runSimulation: (increment) ->
    for object in @objects
      body = object.physics
      position = body.position
      velocity = body.velocity

      position[0] += velocity[0]*increment
      position[1] += velocity[1]*increment

      @_collideWorldBounds body

    return

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
      body.velocity[1] = 0
      body.position[1] = bottom + halfHeight + boundingBox.y

    if max_y >= top
      body.velocity[1] = 0
      body.position[1] = top - halfHeight + boundingBox.y

    if min_x <= left
      body.velocity[0] = 0
      body.position[0] = left + halfWidth - boundingBox.x

    if max_x >= right
      body.velocity[0] = 0
      body.position[0] = right - halfWidth - boundingBox.x

  _updateObjectTransforms: ->
    for object in @objects
      transform = object.transform
      body = object.physics
      transform.position[0] = body.position[0]
      transform.position[1] = body.position[1]

    return

`export default ArcadePhysicsWorld`

