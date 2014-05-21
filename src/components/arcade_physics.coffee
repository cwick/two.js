`import Mixin from "../mixin"`
`import Vector2d from "../vector2d"`
`import Rectangle from "../rectangle"`

ArcadePhysics = Mixin.create
  initialize: ->
    @physics =
      userData: @
      velocity: new Vector2d()
      acceleration: new Vector2d()
      position: new Vector2d()
      boundingBox: new Rectangle()
      maxVelocity: new Vector2d([Number.MAX_VALUE, Number.MAX_VALUE])
      drag: new Vector2d()
      touching:
        up: false
        down: false
        left: false
        right: false

`export default ArcadePhysics`

