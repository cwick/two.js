`import TwoObject from "./object"`
`import Property from "./property"`
`import CanvasRenderer from "./canvas_renderer"`
`import Color from "./color"`

SceneRenderer = TwoObject.extend
  initialize: ->
    @_backend = new CanvasRenderer()

  canvas: Property
    set: (value) -> @_backend.canvas = value

  backend: Property readonly: true

  render: ->
    @_backend.execute
      name: "clear"
      color: new Color(r:10, g: 30, b: 180)

    image = new Image()
    image.src = "https://upload.wikimedia.org/wikipedia/en/6/65/Hello_logo_sm.gif"

    @_backend.execute
      name: "drawImage"
      image: image
      transform: [2, 0, 0, 2, 0, 0]


`export default SceneRenderer`
