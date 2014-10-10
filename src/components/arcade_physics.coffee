`import ArcadePhysicsBody from "../arcade_physics_body"`
`import BaseComponent from "./base"`
`import TransformComponent from "./transform"`

ArcadePhysics = BaseComponent.extend
  initialize: ->
    @body = new ArcadePhysicsBody()

  componentWasInstalled: (gameObject) ->
    gameObject.physics = @body

    unless gameObject.hasComponent("Transform")
      gameObject.addComponent TransformComponent

    @body.userData = gameObject

ArcadePhysics.componentName = "ArcadePhysics"
ArcadePhysics.propertyName = "physics"

`export default ArcadePhysics`

