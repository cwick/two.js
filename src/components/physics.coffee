`import Mixin from "../mixin"`
`import Vector2d from "../vector2d"`

Physics = Mixin.create
  initialize: ->
    @physics =
      velocity: new Vector2d()

`export default Physics`
