`import TwoObject from "./object"`
`import CanHaveParent from "./can_have_parent"`
`import Property from "./property"`

Sprite = TwoObject.extend CanHaveParent,
  initialize: ->
    @anchorPoint = [0.5, 0.5]
    @crop = null

  clone: ->
    new Sprite
      image: @_image
      anchorPoint: @anchorPoint.slice(0)
      width: @width
      height: @height
      crop: @crop?.clone()

  pixelOrigin: Property
    get: ->
      image = @image
      return [0,0] unless image?.complete?

      w = image.width
      h = image.height

      [ @anchorPoint[0] * w,
        h - @anchorPoint[1] * h
      ]

  image: Property
    set: (value) ->
      if typeof value is "string"
        @_image = new Image()
        @_image.src = value
      else
        @_image = value

      unless @_image.complete
        previousonload = @_image.onload
        @_image.onload = =>
          # Not a typo. We need to call the origin setter
          # again so pixelOrigin is properly calculated
          @origin = @origin
          @_image.onload = previousonload
          @_image.onload?()

`export default Sprite`
