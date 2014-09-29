`import TwoObject from "./object"`
`import CanHaveParent from "./can_have_parent"`
`import SceneNode from "./scene_node"`

RenderNode = SceneNode.extend CanHaveParent,
  initialize: ->
    @elements = []

  add: (component) ->
    @elements.push component

  pushRenderCommands: (commands, transform) ->
    component.pushRenderCommands commands, transform for component in @elements

`export default RenderNode`

