`import BaseComponent from "./base"`
`module p2 from "../lib/p2"`

P2Physics = BaseComponent.extend
  initialize: (options) ->
    @body = new p2.Body()
    @body.userData = options.gameObject

P2Physics.componentName = "P2Physics"
P2Physics.propertyName = "physics"
P2Physics.hasConvenienceProperty = true

`export default P2Physics`
