`import Log from "./log"`
`import TwoObject from "./object"`
`import Property from "./property"`
`import Canvas from "./canvas"`
`import SceneRenderer from "./scene_renderer"`
`import CanvasRenderer from "./canvas_renderer"`
`import Camera from "./camera"`
`import TransformNode from "./transform_node"`
`import GameWorld from "./game_world"`
`import Keyboard from "./keyboard"`
`import GameObject from "./game_object"`
`import Rectangle from "./rectangle"`
`import AssetLoader from "./asset_loader"`
`import StateManager from "./state_manager"`
`import Debug from "./debug"`
`import EventQueue from "./event_queue"`
`import GameState from "./game_state"`
`import { Profiler } from "./benchmark"`

MainState = GameState.extend()

DefaultGameDelegate = TwoObject.extend
  domElementForGame: ->
    elementId = "two-game"
    element = document.getElementById(elementId)

    unless element?
      Log.warning("Could not find document element with ID='#{elementId}' to attach a canvas. " +
          "Continuing in off-screen rendering mode.")

    element

  gameDidInitialize: (game) ->
    game.registerState "main", MainState

Game = TwoObject.extend
  initialize: ->
    @delegate = new DefaultGameDelegate()
    @canvas = new Canvas()
    @camera = new Camera()
    @scene = new TransformNode()
    @world = new GameWorld()
    @input = { keyboard: new Keyboard(@) }
    @loader = new AssetLoader()
    @debug = new Debug()
    @_entityClasses = {}
    @_stateManager = new StateManager(game: @)
    @_eventQueue = new EventQueue()

  canvas: Property
    set: (value) ->
      @_canvas = value
      @renderer = new SceneRenderer(backend: new CanvasRenderer(canvas: value))

  start: ->
    @startFromInitialState "main"

  startFromInitialState: (state) ->
    @delegate.gameWillInitialize?(@)
    @_initializeWorld()
    @_initializeCanvas()
    @_initializeCamera()
    @_initializeInput()
    @delegate.gameDidInitialize?(@)

    if @_stateManager.transitionTo state
      @_mainLoop()
    else
      Log.error("Failed initial state transition to '#{state}'. State is not registered.")


  spawn: (type, options={}) ->
    object = @_initializeEntity(type)
    throw new Error("Game#spawn -- Unknown game object type '#{type}'") unless object?

    object.name = options.name if options.name?.length > 0

    @scene.add object.components.transform.node if object.hasComponent("Transform")
    @world.add object
    object.spawn(options)
    object

  registerGameObject: (name, Entity) ->
    @_entityClasses[name] = Entity

  registerState: ->
    @_stateManager.register.apply @_stateManager, arguments

  setTimeout: (delayInSeconds, callback) ->
    @_eventQueue.schedule.apply @_eventQueue, arguments

  defer: (frameCount, callback) ->
    @_eventQueue.frameDelay.apply @_eventQueue, arguments

  remove: (entity) ->
    @world.remove entity
    entity.transform.parent?.remove entity.transform

  _mainLoop: (timestamp) ->
    Profiler.reset()

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

  _render: ->
    @_stateManager.sceneWillRender()
    @renderer.render(@scene, @camera)

  _initializeCanvas: ->
    element = @delegate.domElementForGame?()

    if element?
      element.appendChild @canvas.domElement
    else
      Log.debug("Game delegate failed to return DOM element.")

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

      Entity.apply entity
      entity.name = "#{type}#{entity.id}" unless entity.name?

      entity

  _initializeWorld: ->
    unless @world.bounds?
      @world.bounds = new Rectangle
        x: 0
        y: 0
        width: @canvas.width
        height: @canvas.height

`export { Game, DefaultGameDelegate }`
