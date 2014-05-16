`import TwoObject from "./object"`
`import Property from "./property"`
`module p2 from "../lib/p2"`

PhysicsWorld = TwoObject.extend
  initialize: ->
    @p2 = new p2.World()
    @_bodyMap = {}

  add: (object) ->
    body = object.rigidBody
    @_bodyMap[body.id] = object
    @p2.addBody body

  step: (increment) ->
    @p2.step increment
    @_updateObjectTransforms()

  _updateObjectTransforms: ->
    for body in @p2.bodies
      object = @_bodyMap[body.id]
      transform = object.transform
      transform.position[0] = body.position[0]
      transform.position[1] = body.position[1]
      transform.rotation = body.angle

`export default PhysicsWorld`
