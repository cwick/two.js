`import TwoObject from "./object"`
`import Property from "./property"`
`import CanvasRenderer from "./canvas_renderer"`
`import Color from "./color"`
`import { DepthFirstTreeIterator } from "./tree_iterators"`
`import RenderNode from "./render_node"`
`import GroupNode from "./group_node"`
`import Color from "./color"`
`import { iterateThroughNestedArrays } from "./utils"`

class TreeIteratorDelegate
  constructor: ->
    @commands = []

  shouldIterationContinue: (node) ->
    node.enabled

  visitNode: (node) ->
    if node instanceof GroupNode
      node.updateMatrix()
    else if node instanceof RenderNode
      @commands.push node.generateRenderCommands node._parent.updateWorldMatrix().clone()

SceneRenderer = TwoObject.extend
  initialize: ->
    @backend = new CanvasRenderer()
    @backgroundColor = "black"

  backgroundColor: Property
    set: (value) ->
      @_backgroundColor = new Color(value)

  render: (scene, camera) ->
    delegate = new TreeIteratorDelegate()
    delegate.commands.push
      name: "clear"
      color: @_backgroundColor

    camera.updateMatrix()
    cameraMatrix = camera.updateWorldMatrix().clone()
      .scale(1/@backend._canvas.width, 1/@backend._canvas.height)
      .invert()

    new DepthFirstTreeIterator(scene).execute delegate

    iterateThroughNestedArrays delegate.commands, (command) =>
      command.transform.preMultiply cameraMatrix if command.transform?
      @backend.execute command

    return

`export default SceneRenderer`
