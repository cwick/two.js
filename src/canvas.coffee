`import TwoObject from "./object"`
`import Property from "./property"`

Canvas = TwoObject.extend
  initialize: ->
    @_domElement = document.createElement("canvas")

  domElement: Property readonly: true
  width: Property set: (value) -> @_width = @_domElement.width = value
  height: Property set: (value) -> @_height = @_domElement.height = value

`export default Canvas`
