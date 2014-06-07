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

Game = TwoObject.extend
  initialize: ->
    @domElement = "game"
    @canvas = new Canvas()
    @camera = new Camera()
    @scene = new TransformNode()
    @world = new GameWorld()
    @input = { keyboard: new Keyboard() }
    @_entityClasses = {}

  canvas: Property
    set: (value) ->
      @_canvas = value
      @renderer = new SceneRenderer(backend: new CanvasRenderer(canvas: value))

  start: ->
    @configure()
    @_initializeWorld()
    @_initializeCanvas()
    @_initializeCamera()
    @_initializeInput()
    @_render()

  # Implement in derived classes
  configure: ->

  update: ->
    @world.step 1/60 # TODO: use variable step?

  spawn: (type) ->
    entity = @_initializeEntity(type)
    @scene.add entity.transform
    @world.add entity
    entity.spawn()
    entity

  registerEntity: (name, Entity) ->
    @_entityClasses[name] = Entity

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
