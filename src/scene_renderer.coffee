`import TwoObject from "./object"`
`import Property from "./property"`
`import CanvasRenderer from "./canvas_renderer"`
`import Color from "./color"`
`import Matrix2d from "./matrix2d"`
`import { DepthFirstTreeIterator } from "./tree_iterators"`
`import Sprite from "./sprite"`

SceneRenderer = TwoObject.extend
  initialize: ->
    @_backend = new CanvasRenderer()

  canvas: Property
    set: (value) -> @_canvas = @_backend.canvas = value

  backend: Property readonly: true

  render: (scene) ->
    commands = []
    devicePixelRatio = @_canvas.devicePixelRatio
    commands.push
      name: "clear"
      color: new Color(r:10, g: 30, b: 180)

    new DepthFirstTreeIterator(scene).execute (node) =>
      if node instanceof Sprite
        image = node._image
        transform = node.parent.worldMatrix.clone()

        # TODO: put device mapping somewhere else
        transform.values[4] *= devicePixelRatio
        transform.values[5] *= devicePixelRatio

        scaleX = scaleY = 1

        if node.width && image.width
          scaleX = node.width / image.width
        if node.height && image.height
          scaleY = node.height / image.height

        transform.scale scaleX, scaleY

        commands.push
          name: "drawImage"
          image: image
          transform: transform
          origin: node._pixelOrigin

    @_backend.execute command for command in commands
    return

`export default SceneRenderer`
