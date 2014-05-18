`import TwoObject from "./object"`
`import Property from "./property"`
`import Canvas from "./canvas"`
`import SceneRenderer from "./scene_renderer"`
`import Camera from "./camera"`
`import TransformNode from "./transform"`
`import GameWorld from "./game_world"`
`import Keyboard from "./keyboard"`

Game = TwoObject.extend
  initialize: ->
    @domElement = "game"
    @canvas = new Canvas()
    @camera = new Camera()
    @scene = new TransformNode()
    @world = new GameWorld()
    @input = { keyboard: new Keyboard() }

  canvas: Property
    set: (value) ->
      @_canvas = value
      @renderer = new SceneRenderer(canvas: value)

  start: ->
    @setup()
    @_initializeCanvas()
    @_initializeCamera()
    @_initializeInput()
    @_render()

  # Implement in derived classes
  setup: ->
  update: ->

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

`export default Game`
