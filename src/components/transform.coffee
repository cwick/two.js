`import Mixin from "../mixin"`
`import TransformNode from "../transform"`

Transform = Mixin.create
  initialize: ->
    @transform = new TransformNode()

`export default Transform`
