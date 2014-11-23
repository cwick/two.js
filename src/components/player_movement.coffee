`import BaseComponent from "./base"`
`import Vector2d from "../vector2d"`

PlayerMovement = BaseComponent.extend
  initialize: ->
    @maxAcceleration = new Vector2d([10,10])

  tick: ->
    input = @owner.consumeInputVector()
    acceleration = @maxAcceleration.clone()
    acceleration.multiply input

    @_limitAcceleration(acceleration)

    @owner.physics.acceleration = acceleration

  _limitAcceleration: (v) ->
    if v.x > @maxAcceleration.x
      v.x = @maxAcceleration.x
    else if v.x < -@maxAcceleration.x
      v.x = -@maxAcceleration.x

    if v.y > @maxAcceleration.y
      v.y = @maxAcceleration.y
    else if v.y < -@maxAcceleration.y
      v.y = -@maxAcceleration.y


PlayerMovement.componentName = "PlayerMovement"
PlayerMovement.propertyName = "movement"

`export default PlayerMovement`


