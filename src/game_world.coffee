`import TwoObject from "./object"`
`import P2PhysicsWorld from "./p2_physics_world"`
`import P2Physics from "./components/p2_physics"`
`import ArcadePhysicsWorld from "./arcade_physics_world"`
`import ArcadePhysics from "./components/arcade_physics"`
`import Rectangle from "./rectangle"`

GameWorld = TwoObject.extend
  initialize: ->
    @bounds = null
    @objects = []
    @physics =
      p2: new P2PhysicsWorld(updateCallback: @_updateP2Objects)
      arcade: new ArcadePhysicsWorld(updateCallback: @_updateArcadeObjects)

  step: (increment) ->
    @_stepGameObjects()
    @_stepPhysics(increment)

  add: (obj) ->
    @objects.push obj

    if P2Physics.detect(obj)
      @physics.p2.add obj.physics
    else if ArcadePhysics.detect(obj)
      @physics.arcade.add obj.physics

  remove: (obj) ->
    idx = @objects.indexOf obj
    if idx != -1
      @objects.splice(idx, 1)

    if P2Physics.detect(obj)
      @physics.p2.remove obj.physics
    else if ArcadePhysics.detect(obj)
      @physics.arcade.remove obj.physics

  _stepGameObjects: ->
    obj.update() for obj in @objects
    return

  _stepPhysics: (increment) ->
    for _, physics of @physics
      physics.bounds = @bounds
      physics.step increment
    return

  _updateArcadeObjects: (bodies) ->
    for body in bodies
      transform = body.userData.transform
      transform.position[0] = body.position[0]
      transform.position[1] = body.position[1]

    return

  _updateP2Objects: (bodies) ->
    for body in bodies
      transform = body.userData.transform
      transform.position[0] = body.position[0]
      transform.position[1] = body.position[1]
      transform.rotation = body.angle

    return

`export default GameWorld`
