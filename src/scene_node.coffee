`import TwoObject from "./object"`
`import Property from "./property"`

SceneNode = TwoObject.extend
  initialize: ->
    @enabled = true
    @_parent = null

  parent: Property readonly: true

  _setParent: (value) ->
    @_parent = value

`export default SceneNode`

