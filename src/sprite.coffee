`import TwoObject from "./object"`
`import CanHaveParent from "./can_have_parent"`
`import Property from "./property"`

Sprite = TwoObject.extend CanHaveParent,
  image: Property
    set: (value) ->
      if typeof value is "string"
        @_image = new Image()
        @_image.src = value
      else
        @_image = value

`export default Sprite`
