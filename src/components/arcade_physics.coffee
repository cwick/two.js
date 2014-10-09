`import ArcadePhysicsBody from "../arcade_physics_body"`
`import BaseComponent from "./base"`

ArcadePhysics = BaseComponent.extend
  initialize: (options) ->
    @body = new ArcadePhysicsBody()
    @body.userData = options.gameObject

ArcadePhysics.componentName = "ArcadePhysics"
ArcadePhysics.propertyName = "physics"
ArcadePhysics.hasConvenienceProperty = true

`export default ArcadePhysics`

