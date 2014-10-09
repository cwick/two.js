`import ArcadePhysicsBody from "../arcade_physics_body"`
`import BaseComponent from "./base"`

ArcadePhysics = BaseComponent.extend
  initialize: ->
    @body = new ArcadePhysicsBody()

  componentWasInstalled: (gameObject) ->
    gameObject.physics = @body
    @body.userData = gameObject

ArcadePhysics.componentName = "ArcadePhysics"
ArcadePhysics.propertyName = "physics"

`export default ArcadePhysics`

