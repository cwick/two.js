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

  render: (scene) ->
    commands = []
    backend = @_backend
    commands.push
      name: "clear"
      color: new Color(r:10, g: 30, b: 180)

    new DepthFirstTreeIterator(scene).execute (node) =>
      if node instanceof GroupNode
        node.updateMatrix()
      else if node instanceof RenderNode
        node.pushRenderCommands commands, node._parent.updateWorldMatrix()

    backend.execute command for command in commands
    return

`export default SceneRenderer`
