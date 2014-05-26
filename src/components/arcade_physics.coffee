`import Mixin from "../mixin"`
`import ArcadePhysicsBody from "../arcade_physics_body"`

ArcadePhysics = Mixin.create
  initialize: ->
    @physics = new ArcadePhysicsBody()
    @physics.userData = @

`export default ArcadePhysics`

