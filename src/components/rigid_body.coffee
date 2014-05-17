`import Mixin from "../mixin"`
`module p2 from "lib/p2"`

RigidBody = Mixin.create
  initialize: ->
    @rigidBody = new p2.Body()

`export default RigidBody`
