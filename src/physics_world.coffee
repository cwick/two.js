`import TwoObject from "./object"`
`import Property from "./property"`
`import Circle from "./circle"`
`import Plane from "./plane"`
`module p2 from "../lib/p2"`

getP2Shape = (src) ->
  if src instanceof Circle
    new p2.Circle(src.radius)
  else if src instanceof Plane
    new p2.Plane()
  else
    throw "Invalid shape"

PhysicsWorld = TwoObject.extend
  initialize: ->
    @_world = new p2.World()
    @_bodyMap = {}

  gravity: Property
    get: -> @_world.gravity[1]
    set: (value) -> @_world.gravity[1] = value

  add: (object) ->
    physics = object.physics
    body = new p2.Body
      mass: physics.mass
      position: object.transform.position
      velocity: physics.velocity

    if physics.type == "static"
      body.motionState = p2.Body.STATIC

    body.damping = 0
    body.angle = object.transform.rotation
    body.addShape(getP2Shape(physics.shape)) if physics.shape?

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
