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
    @touching =
      up: false
      down: false
      left: false
      right: false

ArcadePhysicsBody.STATIC = 0
ArcadePhysicsBody.DYNAMIC = 1

`export default ArcadePhysicsBody`
