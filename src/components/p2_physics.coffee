`import Mixin from "../mixin"`
`module p2 from "../lib/p2"`

P2Physics = Mixin.create
  initialize: ->
    @physics = new p2.Body()
    @physics.userData = @

`export default P2Physics`
