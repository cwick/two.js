`import TwoObject from "./object"`
`import Property from "./property"`
`import CanvasRenderer from "./canvas_renderer"`
`import Color from "./color"`
`import { DepthFirstTreeIterator } from "./tree_iterators"`
`import RenderNode from "./render_node"`
`import GroupNode from "./group"`
`import Color from "./color"`

SceneRenderer = TwoObject.extend
  initialize: ->
    @backend = new CanvasRenderer()
    @backgroundColor = "black"

  backgroundColor: Property
    set: (value) ->
      @_backgroundColor = new Color(value)

  render: (scene, camera) ->
    commands = []
    commands.push
      name: "clear"
      color: @_backgroundColor

    camera.updateMatrix()
    cameraMatrix = camera.updateWorldMatrix().clone()
      .scale(1/@backend._canvas.width, 1/@backend._canvas.height)
      .invert()

    new DepthFirstTreeIterator(scene).execute (node) =>
      if node instanceof GroupNode
        node.updateMatrix()
      else if node instanceof RenderNode
        node.pushRenderCommands commands, node._parent.updateWorldMatrix().clone()

    for command in commands
      command.transform.preMultiply cameraMatrix if command.transform?
      @backend.execute command

    return

`export default SceneRenderer`
