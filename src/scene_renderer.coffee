`import TwoObject from "./object"`
`import Property from "./property"`
`import CanvasRenderer from "./canvas_renderer"`
`import Color from "./color"`

SceneRenderer = TwoObject.extend
  initialize: ->
    @_backend = new CanvasRenderer()

  canvas: Property
    set: (value) -> @_backend.canvas = value

  render: ->
    @_backend.execute
      name: "clear"
      color: new Color(r:10, g: 30, b: 180)

`export default SceneRenderer`
