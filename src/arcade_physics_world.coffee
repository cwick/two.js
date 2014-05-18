`import TwoObject from "./object"`
`import Property from "./property"`

ArcadePhysicsWorld = TwoObject.extend
  initialize: ->
    @objects = []

  add: (object) ->
    @objects.push object

  step: (increment) ->
    @_runSimulation(increment)
    @_updateObjectTransforms()

  _runSimulation: (increment) ->
    for object in @objects
      body = object.physics
      position = body.position
      velocity = body.velocity

      position[0] += velocity[0]*increment
      position[1] += velocity[1]*increment

    return

  _updateObjectTransforms: ->
    for object in @objects
      transform = object.transform
      body = object.physics
      transform.position[0] = body.position[0]
      transform.position[1] = body.position[1]

    return

`export default ArcadePhysicsWorld`

