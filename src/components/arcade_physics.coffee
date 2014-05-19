`import Mixin from "../mixin"`
`import Vector2d from "../vector2d"`
`import Rectangle from "../rectangle"`

ArcadePhysics = Mixin.create
  initialize: ->
    @physics =
      velocity: new Vector2d()
      position: new Vector2d()
      boundingBox: new Rectangle()

`export default ArcadePhysics`

