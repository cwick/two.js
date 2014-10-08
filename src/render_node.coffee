`import SceneNode from "./scene_node"`
`import Renderable from "./renderable"`
`import Property from "./property"`

RenderNode = SceneNode.extend
  initialize: ->
    @renderable = new Renderable()
    @width = @height = null

  generateRenderCommands: ->
    commands = @renderable.generateRenderCommands()

    [ @_getTransformCommand(@parent.worldMatrix), commands ]

  _getTransformCommand: (transform) ->
    transform = transform.clone()
    scaleX = scaleY = 1
    bounds = @renderable.bounds

    if @width && bounds.width
      scaleX = @width / bounds.width
    if @height && bounds.height
      scaleY = @height / bounds.height

    transform.scale scaleX, scaleY

    { name: "setTransform", matrix: transform }

`export default RenderNode`

