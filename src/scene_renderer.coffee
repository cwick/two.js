`import TwoObject from "./object"`
`import Property from "./property"`
`import CanvasRenderer from "./canvas_renderer"`
`import Color from "./color"`
`import { DepthFirstTreeIterator } from "./tree_iterators"`
`import RenderNode from "./render_node"`
`import GroupNode from "./group"`

SceneRenderer = TwoObject.extend
  initialize: ->
    @_backend = new CanvasRenderer()

  canvas: Property
    set: (value) -> @_canvas = @_backend.canvas = value

  backend: Property readonly: true

  render: (scene, camera) ->
    commands = []
    backend = @_backend
    commands.push
      name: "clear"
      color: new Color(r:10, g: 30, b: 180)

    camera.updateMatrix()
    cameraMatrix = camera.updateWorldMatrix().clone()
      .scale(1/@_canvas.width, 1/@_canvas.height)
      .invert()

    new DepthFirstTreeIterator(scene).execute (node) =>
      if node instanceof GroupNode
        node.updateMatrix()
      else if node instanceof RenderNode
        node.pushRenderCommands commands, node._parent.updateWorldMatrix().clone()

    for command in commands
      command.transform.preMultiply cameraMatrix if command.transform?
      backend.execute command

    return

`export default SceneRenderer`
