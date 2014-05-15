`import TwoObject from "./object"`
`import CanHaveParent from "./can_have_parent"`
`import Property from "./property"`

Sprite = TwoObject.extend CanHaveParent,
  initialize: ->
    @origin = [0,0]
    @crop = null

  origin: Property
    set: (value) ->
      if value == "center"
        @_pixelOrigin = [ @image.width / 2, @image.height / 2 ] if @image?.complete
      else if value instanceof Array
        @_pixelOrigin = value
      else
        throw new Error("Invalid value \"#{value}\" for origin")

      @_origin = value

  pixelOrigin: Property readonly: true

  clone: ->
    new Sprite
      image: @_image
      origin: @origin.slice(0)
      width: @width
      height: @height
      crop: @crop?.clone()

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
