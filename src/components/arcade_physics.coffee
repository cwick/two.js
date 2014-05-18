`import Mixin from "../mixin"`
`import Vector2d from "../vector2d"`

ArcadePhysics = Mixin.create
  initialize: ->
    @physics =
      velocity: new Vector2d()
      position: new Vector2d()

`export default ArcadePhysics`

