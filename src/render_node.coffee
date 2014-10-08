`import SceneNode from "./scene_node"`
`import Renderable from "./renderable"`

RenderNode = SceneNode.extend
  initialize: ->
    @renderable = new Renderable()

  ###*
  #
  # @method generateRenderCommands
  # @param {Matrix2d} worldTransform The world transformation matrix for this
  #   RenderNode, computed from its position in the scene graph hierarchy.
  # @return An array of render commands, or a single render command, that will render this node
  ###
  generateRenderCommands: (worldTransform) ->
    @renderable.generateRenderCommands worldTransform

`export default RenderNode`

