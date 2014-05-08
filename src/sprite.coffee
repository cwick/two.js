`import TwoObject from "./object"`
`import CanHaveParent from "./can_have_parent"`
`import Property from "./property"`
`import DEFAULT_IMAGE from "./default_sprite_image"`

Sprite = TwoObject.extend CanHaveParent,
  initialize: ->
    @origin = [0,0]
    @image = @_specifiedImage = DEFAULT_IMAGE
    @usePlaceholder = true

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

  usePlaceholder: Property
    set: (value) ->
      @_usePlaceholder = value

      if value && !@_specifiedImage.complete
        # Temporarily swap out the current image for the default one
        # while we wait for the original image to load.
        @_image = DEFAULT_IMAGE
        previousonload = @_specifiedImage.onload
        @_specifiedImage.onload = =>
          @image = @_specifiedImage
          # Not a typo. We need to call the origin setter
          # again so pixelOrigin is properly calculated
          @origin = @origin
          previousonload?()
      else
        @_image = @_specifiedImage

  image: Property
    set: (value) ->
      if typeof value is "string"
        @_image = new Image()
        @_image.src = value
      else
        @_image = value

      @_specifiedImage = @_image
      @usePlaceholder = @usePlaceholder



`export default Sprite`
