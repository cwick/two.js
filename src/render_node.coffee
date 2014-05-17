`import TwoObject from "./object"`
`import CanHaveParent from "./can_have_parent"`

RenderNode = TwoObject.extend CanHaveParent,
  initialize: ->
    @components = []

  add: (component) ->
    @components.push component

  pushRenderCommands: (commands, transform) ->
    component.pushRenderCommands commands, transform for component in @components

`export default RenderNode`

