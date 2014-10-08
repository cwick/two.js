`import TwoObject from "./object"`
`import SceneNode from "./scene_node"`

RenderNode = SceneNode.extend
  initialize: ->
    @elements = []

  add: (component) ->
    @elements.push component

  ###*
  #
  # @method pushRenderCommands
  # @param {Array} outCommands An array onto which this RenderNode should push its
  #   render commands.
  # @param {Matrix2d} worldTransform The world transformation matrix for this
  #   RenderNode, computed from its position in the scene graph hierarchy.
  ###
  pushRenderCommands: (outCommands, worldTransform) ->
    component.pushRenderCommands outCommands, worldTransform for component in @elements

`export default RenderNode`

