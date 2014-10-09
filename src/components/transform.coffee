`import BaseComponent from "./base"`
`import TransformNode from "../transform_node"`

TransformComponent = BaseComponent.extend
  initialize: ->
    @node = new TransformNode()

TransformComponent.componentName = "Transform"
TransformComponent.propertyName = "transform"
TransformComponent.hasConvenienceProperty = true

`export default TransformComponent`
