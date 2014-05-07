`import TwoObject from "./object"`
`import Property from "./property"`
`import CanvasRenderer from "./canvas_renderer"`
`import Color from "./color"`
`import Matrix2d from "./matrix2d"`
`import { BreadthFirstTreeIterator } from "./tree_iterators"`
`import Sprite from "./sprite"`

SceneRenderer = TwoObject.extend
  initialize: ->
    @_backend = new CanvasRenderer()

  canvas: Property
    set: (value) -> @_canvas = @_backend.canvas = value

  backend: Property readonly: true

  render: (scene) ->
    @_backend.execute
      name: "clear"
      color: new Color(r:10, g: 30, b: 180)

    transform = new Matrix2d()
    iterator = new BreadthFirstTreeIterator(scene)

    while iterator.hasNext
      node = iterator.next()
      if node instanceof Sprite
        transform = node.parent.worldMatrix.clone()
        transform.values[4] *= @_canvas.devicePixelRatio
        transform.values[5] *= @_canvas.devicePixelRatio

        @_backend.execute
          name: "drawImage"
          image: node.image
          transform: transform

`export default SceneRenderer`
