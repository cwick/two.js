`import TwoObject from "./object"`
`import Property from "./property"`
`import Canvas from "./canvas"`
`import SceneRenderer from "./scene_renderer"`
`import CanvasRenderer from "./canvas_renderer"`
`import Camera from "./camera"`
`import TransformNode from "./transform"`
`import GameWorld from "./game_world"`
`import Keyboard from "./keyboard"`
`import GameObject from "./game_object"`
`import Rectangle from "./rectangle"`
`import AssetLoader from "./asset_loader"`
`import StateManager from "./state_manager"`
`import Debug from "./debug"`
`import EventQueue from "./event_queue"`
`import { Profiler } from "./benchmark"`

Game = TwoObject.extend
  initialize: ->
    @domElement = "game"
    @canvas = new Canvas()
    @camera = new Camera()
    @scene = new TransformNode()
    @world = new GameWorld()
    @input = { keyboard: new Keyboard() }
    @loader = new AssetLoader()
    @debug = new Debug()
    @_entityClasses = {}
    @_stateManager = new StateManager(game: @)
    @_eventQueue = new EventQueue()
    @_deferredActions = []

  canvas: Property
    set: (value) ->
      @_canvas = value
      @renderer = new SceneRenderer(backend: new CanvasRenderer(canvas: value))

  start: (initialState="main") ->
    @configure()
    @_initializeWorld()
    @_initializeCanvas()
    @_initializeCamera()
    @_initializeInput()
    @_stateManager.transitionTo initialState if @_stateManager.isStateRegistered(initialState)
    @_mainLoop()

  # Implement in derived classes
  configure: ->

  spawn: (type, options={}) ->
    entity = @_initializeEntity(type)
    throw new Error("Game#spawn -- Unknown entity type '#{type}'") unless entity?

    entity.name = options.name if options.name?.length > 0

    @scene.add entity.transform
    @defer => @world.add entity
    entity.spawn(options)
    entity

  registerEntity: (name, Entity) ->
    @_entityClasses[name] = Entity

  registerState: ->
    @_stateManager.register.apply @_stateManager, arguments

  setTimeout: (delay, callback) ->
    @_eventQueue.schedule delay, callback

  defer: (callback) ->
    @_deferredActions.push callback

  remove: (entity) ->
    @defer => @world.remove entity
    entity.transform.parent?.remove entity.transform

  _mainLoop: (timestamp) ->
    Profiler.resetFrames()

    Profiler.measure "mainLoop", =>
      @debug._updateFramesPerSecond(timestamp)

      @_tick()
      Profiler.measure "render", => @_render()

      requestAnimationFrame(@_mainLoop.bind @)

    @debug._updateStatistics()

  _tick: ->
    DELTA_SECONDS = 1/60 # TODO: use variable step?
    @_stateManager.tick DELTA_SECONDS
    @_eventQueue.tick DELTA_SECONDS
    @world.tick DELTA_SECONDS
    @_executeDeferredActions()

  _render: ->
    @_stateManager.beforeRender()
    @renderer.render(@scene, @camera)

  _initializeCanvas: ->
    document.getElementById(@domElement)?.appendChild @canvas.domElement

  _initializeCamera: ->
    @camera.width = @canvas.width unless @camera.width?
    @camera.height = @canvas.height unless @camera.height?

  _initializeInput: ->
    @input.keyboard.start()

  _initializeEntity: (type) ->
    Entity = @_entityClasses[type]

    if Entity
      entity = Object.create Entity.prototype
      entity.game = @
      entity.name = "#{type}#{entity.id}"

      Entity.apply entity
      entity

  _initializeWorld: ->
    unless @world.bounds?
      @world.bounds = new Rectangle
        x: 0
        y: 0
        width: @canvas.width
        height: @canvas.height

  _executeDeferredActions: ->
    actions = @_deferredActions
    @_deferredActions = []

    callback() for callback in actions

    return

`export default Game`
