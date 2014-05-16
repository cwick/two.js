`import Mixin from "../mixin"`
`import Vector2d from "../vector2d"`

Physics = Mixin.create
  initialize: ->
    @physics =
      velocity: new Vector2d()
      shape: null
      mass: 1

`export default Physics`
