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

Game = TwoObject.extend
  initialize: ->
    @domElement = "game"
    @canvas = new Canvas()
    @camera = new Camera()
    @scene = new TransformNode()
    @world = new GameWorld()
    @input = { keyboard: new Keyboard() }
    @loader = new AssetLoader()
    @_entityClasses = {}
    @_stateManager = new StateManager(game: @)

  canvas: Property
    set: (value) ->
      @_canvas = value
      @renderer = new SceneRenderer(backend: new CanvasRenderer(canvas: value))

  start: (initialState) ->
    @configure()
    @_initializeWorld()
    @_initializeCanvas()
    @_initializeCamera()
    @_initializeInput()
    @_render()
    @_stateManager.transitionTo initialState if initialState

  # Implement in derived classes
  configure: ->

  update: ->
    INCREMENT = 1/60 # TODO: use variable step?
    @_stateManager.step INCREMENT
    @world.step INCREMENT

  spawn: (type) ->
    entity = @_initializeEntity(type)
    throw new Error("Game#spawn -- Unknown entity type '#{type}'") unless entity?

    @scene.add entity.transform
    @world.add entity
    entity.spawn()
    entity

  registerEntity: (name, Entity) ->
    @_entityClasses[name] = Entity

  registerState: ->
    @_stateManager.register.apply @_stateManager, arguments

  _render: ->
    requestAnimationFrame(@_render.bind @)
    @update()
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

      Entity.apply entity
      entity

  _initializeWorld: ->
    unless @world.bounds?
      @world.bounds = new Rectangle
        x: 0
        y: 0
        width: @canvas.width
        height: @canvas.height

`export default Game`
