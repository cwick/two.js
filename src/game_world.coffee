`import TwoObject from "./object"`
`import P2PhysicsWorld from "./p2_physics_world"`
`import P2Physics from "./components/p2_physics"`
`import Property from "./property"`
`import ArcadePhysicsWorld from "./arcade_physics_world"`
`import ArcadePhysics from "./components/arcade_physics"`
`import Rectangle from "./rectangle"`
`import { Profiler } from "./benchmark"`
`import Log from "./log"`

GameWorld = TwoObject.extend
  initialize: ->
    @bounds = null
    @_entitiesByID = []
    @_entitiesByName = []
    @_gameObjectCount = 0
    @physics =
      p2: new P2PhysicsWorld(updateCallback: @_updateP2Objects)
      arcade: new ArcadePhysicsWorld(updateCallback: @_updateArcadeObjects)

  tick: (deltaSeconds) ->
    Profiler.measure "logic", => @_tickGameObjects()
    Profiler.measure "physics", => @_tickPhysics(deltaSeconds)

  gameObjectCount: Property readonly: true

  add: (obj) ->
    throw new Error("Entities must have a unique ID") if @_entitiesByID[obj.id] || !obj.id?

    @_entitiesByName[obj.name] = obj if obj.name?.length > 0
    @_entitiesByID[obj.id] = obj
    @_gameObjectCount++

    if obj.hasComponent("P2Physics")
      @physics.p2.add obj.components.physics.body
    else if obj.hasComponent("ArcadePhysics")
      @physics.arcade.add obj.components.physics.body

  remove: (obj) ->
    if @_entitiesByID[obj.id]
      delete @_entitiesByID[obj.id]
      @_gameObjectCount--

    delete @_entitiesByName[obj.name]

    if obj.hasComponent("P2Physics")
      @physics.p2.remove obj.components.physics.body
    else if obj.hasComponent("ArcadePhysics")
      @physics.arcade.remove obj.components.physics.body

  findByName: (name) ->
    @_entitiesByName[name]

  _tickGameObjects: ->
    @_entitiesByID[id].tick() for id of @_entitiesByID
    return

  _tickPhysics: (deltaSeconds) ->
    for _, physics of @physics
      physics.bounds = @bounds
      physics.tick deltaSeconds
    return

  _updateArcadeObjects: (bodies) ->
    for body in bodies when body.enabled
      transform = body.userData.components.transform?.node
      if transform
        transform.position[0] = body.position[0]
        transform.position[1] = body.position[1]
      else
        Log.warning("Can't update physics on #{body.userData.name}. Object has no Transform component.")

    return

  _updateP2Objects: (bodies) ->
    for body in bodies
      transform = body.userData.components.transform?.node
      if transform
        transform.position[0] = body.position[0]
        transform.position[1] = body.position[1]
        transform.rotation = body.angle
      else
        Log.warning("Can't update physics on #{body.userData.name}. Object has no Transform component.")

    return

`export default GameWorld`
