`import TwoObject from "./object"`
`import CanHaveParent from "./can_have_parent"`

RenderNode = TwoObject.extend CanHaveParent,
  initialize: ->
    @elements = []

  add: (component) ->
    @elements.push component

  pushRenderCommands: (commands, transform) ->
    component.pushRenderCommands commands, transform for component in @elements

`export default RenderNode`

