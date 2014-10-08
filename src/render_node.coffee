`import SceneNode from "./scene_node"`

RenderNode = SceneNode.extend
  add: (child) ->
    throw new Error("RenderNodes cannot have children")

  ###*
  #
  # @method generateRenderCommands
  # @param {Matrix2d} worldTransform The world transformation matrix for this
  #   RenderNode, computed from its position in the scene graph hierarchy.
  # @return An array of render commands, or a single render command, that will render this node
  ###
  generateRenderCommands: (outCommands, worldTransform) ->
    component.generateRenderCommands outCommands, worldTransform for component in @elements

`export default RenderNode`

