`import Mixin from "./mixin"`
`import Property from "./property"`

TransformHelpers = Mixin.create
  initialize: ->
    @_rotation = 0

  rotation: Property
    set: (value) ->
      @_base._matrix.reset().rotate(value)

`export default TransformHelpers`
