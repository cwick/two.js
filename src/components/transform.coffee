`import Mixin from "../mixin"`
`import TransformNode from "../transform_node"`

Transform = Mixin.create
  initialize: ->
    @transform = new TransformNode()

`export default Transform`
