`import Mixin from "./mixin"`
`import Property from "./property"`

CanHaveParent = Mixin.create
  initialize: ->
    @_parent = null

  parent: Property readonly: true

  _setParent: (value) ->
    @_parent = value

`export default CanHaveParent`
