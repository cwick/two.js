`import SceneNode from "./scene_node"`
`import Renderable from "./renderable"`
`import Property from "./property"`

RenderNode = SceneNode.extend
  initialize: ->
    @renderable = new Renderable()
    @width = @height = null

  ###*
  #
  # @method generateRenderCommands
  # @param {Matrix2d} worldTransform The world transformation matrix for this
  #   RenderNode, computed from its position in the scene graph hierarchy.
  # @return An array of render commands, or a single render command, that will render this node
  ###
  generateRenderCommands: (worldTransform) ->
    commands = @renderable.generateRenderCommands(worldTransform)

    scaleX = scaleY = 1

    if @width && @renderable.width
      scaleX = @width / @renderable.width
    if @height && @renderable.height
      scaleY = @height / @renderable.height

    worldTransform.scale scaleX, scaleY

    [ @_transformCommand(worldTransform), commands ]

  _transformCommand: (transform) ->
    { name: "setTransform", matrix: transform }

`export default RenderNode`

