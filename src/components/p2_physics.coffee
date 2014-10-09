`import BaseComponent from "./base"`
`module p2 from "../lib/p2"`

P2Physics = BaseComponent.extend
  initialize: ->
    @body = new p2.Body()

  componentWasInstalled: (gameObject) ->
    gameObject.physics = @body
    @body.userData = gameObject

P2Physics.componentName = "P2Physics"
P2Physics.propertyName = "physics"

`export default P2Physics`
