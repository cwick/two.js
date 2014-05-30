`import TwoObject from "./object"`
`import Vector2d from "../vector2d"`
`import Rectangle from "../rectangle"`

ArcadePhysicsBody = TwoObject.extend
  initialize: ->
    @collideWorldBounds = false
    @userData = null
    @velocity = new Vector2d()
    @acceleration = new Vector2d()
    @position = new Vector2d()
    @boundingBox = new Rectangle()
    @boundingBoxLimits =
      minX: 0.0
      maxX: 0.0
      minY: 0.0
      maxY: 0.0
    @maxVelocity = new Vector2d([Number.MAX_VALUE, Number.MAX_VALUE])
    @drag = new Vector2d()
    @type = ArcadePhysicsBody.DYNAMIC
    @touching =
      up: false
      down: false
      left: false
      right: false

  updateBoundingBoxLimits: ->
    position = @position
    boundingBox = @boundingBox
    limits = @boundingBoxLimits

    halfWidth = boundingBox.width/2
    halfHeight = boundingBox.height/2

    center_x = position[0] - boundingBox.x
    center_y = position[1] - boundingBox.y

    limits.minX = center_x - halfWidth
    limits.maxX = center_x + halfWidth
    limits.minY = center_y - halfHeight
    limits.maxY = center_y + halfHeight

    limits

  resetTouching: ->
    @touching.up = @touching.down = @touching.left = @touching.right = false

ArcadePhysicsBody.STATIC = 0
ArcadePhysicsBody.DYNAMIC = 1

`export default ArcadePhysicsBody`
