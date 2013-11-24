define ["./box", "./sprite_material"], (Box, SpriteMaterial) ->
  class Sprite extends Box
    constructor: (options) ->
      unless options.material instanceof SpriteMaterial
        throw new Error("Material must be instance of SpriteMaterial")

      width = options.width
      height = options.height
      name = options.name
      image = options.material.image

      autoSize = !width? || !height?

      super

      unless name
        @setName "#{image?.getPath()} (#{@getId()})"

      if autoSize
        image?.loaded.addOnce (=> @_onImageLoaded(width, height)), @, 1

    _onImageLoaded: (width, height) ->
      if !width? && !height?
        height = 2

      image = @material.image

      if height?
        @setHeight(height)
        @setWidth((image.getWidth() / image.getHeight())*@getHeight())
      else if width?
        @setWidth(width)
        @setHeight((image.getHeight() / image.getWidth())*@getWidth())

      return true
