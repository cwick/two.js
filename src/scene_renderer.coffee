`import TwoObject from "./object"`
`import Property from "./property"`
`import CanvasRenderer from "./canvas_renderer"`
`import Color from "./color"`
`import { BreadthFirstTreeIterator } from "./tree_iterators"`
`import Sprite from "./sprite"`
`module gl from "lib/gl-matrix"`

SceneRenderer = TwoObject.extend
  initialize: ->
    @_backend = new CanvasRenderer()

  canvas: Property
    set: (value) -> @_backend.canvas = value

  backend: Property readonly: true

  render: (scene) ->
    @_backend.execute
      name: "clear"
      color: new Color(r:10, g: 30, b: 180)

    iterator = new BreadthFirstTreeIterator(scene)

    while iterator.hasNext
      node = iterator.next()
      if node instanceof Sprite
        @_backend.execute
          name: "drawImage"
          image: node.image
          transform: node.parent.worldMatrix

`export default SceneRenderer`
