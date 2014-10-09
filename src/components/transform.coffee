`import BaseComponent from "./base"`
`import TransformNode from "../transform_node"`

TransformComponent = BaseComponent.extend
  initialize: ->
    @node = new TransformNode()

  componentWasInstalled: (gameObject) ->
    gameObject.transform = @node

TransformComponent.componentName = "Transform"
TransformComponent.propertyName = "transform"

`export default TransformComponent`
