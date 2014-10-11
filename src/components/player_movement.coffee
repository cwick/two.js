`import BaseComponent from "./base"`
`import Vector2d from "../vector2d"`

PlayerMovement = BaseComponent.extend
  initialize: ->
    @maxAcceleration = new Vector2d([10,10])

  tick: ->
    input = @owner.consumeInputVector()
    input.normalize()
    acceleration = @maxAcceleration.clone()
    acceleration.multiply input

    @owner.physics.acceleration = acceleration

PlayerMovement.componentName = "PlayerMovement"
PlayerMovement.propertyName = "movement"

`export default PlayerMovement`


