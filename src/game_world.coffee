`import TwoObject from "./object"`
`import P2PhysicsWorld from "./p2_physics_world"`
`import P2Physics from "./components/p2_physics"`
`import Property from "./property"`
`import ArcadePhysicsWorld from "./arcade_physics_world"`
`import ArcadePhysics from "./components/arcade_physics"`
`import Rectangle from "./rectangle"`

GameWorld = TwoObject.extend
  initialize: ->
    @bounds = null
    @_entitiesByID = []
    @_entityCount = 0
    @physics =
      p2: new P2PhysicsWorld(updateCallback: @_updateP2Objects)
      arcade: new ArcadePhysicsWorld(updateCallback: @_updateArcadeObjects)

  step: (increment) ->
    @_stepGameObjects()
    @_stepPhysics(increment)

  entityCount: Property readonly: true

  add: (obj) ->
    throw new Error("Entities must have a unique ID") if @_entitiesByID[obj.id] || !obj.id?

    @_entitiesByID[obj.id] = obj
    @_entityCount++

    if P2Physics.detect(obj)
      @physics.p2.add obj.physics
    else if ArcadePhysics.detect(obj)
      @physics.arcade.add obj.physics

  remove: (obj) ->
    if @_entitiesByID[obj.id]
      delete @_entitiesByID[obj.id]
      @_entityCount--

    if P2Physics.detect(obj)
      @physics.p2.remove obj.physics
    else if ArcadePhysics.detect(obj)
      @physics.arcade.remove obj.physics

  _stepGameObjects: ->
    @_entitiesByID[id].update() for id of @_entitiesByID
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
