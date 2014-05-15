`import TwoObject from "./object"`
`import Property from "./property"`
`module p2 from "../lib/p2"`

PhysicsWorld = TwoObject.extend
  initialize: ->
    @_world = new p2.World()
    @_bodyMap = {}

  gravity: Property
    get: -> @_world.gravity[1]
    set: (value) -> @_world.gravity[1] = value

  add: (object) ->
    body = new p2.Body
      mass: 1
      position: object.transform.position
      velocity: object.physics.velocity

    body.damping = 0
    body.addShape new p2.Circle(object.physics.shape.radius)

    @_bodyMap[body.id] = object
    @_world.addBody body

  step: (increment) ->
    @_world.step increment
    @_updateObjectTransforms()

  _updateObjectTransforms: ->
    for body in @_world.bodies
      object = @_bodyMap[body.id]
      transform = object.transform
      transform.position[0] = body.position[0]
      transform.position[1] = body.position[1]

`export default PhysicsWorld`
