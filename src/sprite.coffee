define ["./box", "./sprite_material"], (Box, SpriteMaterial) ->
  class Sprite extends Box
    constructor: (options) ->
      unless options.material instanceof SpriteMaterial
        throw new Error("Material must be instance of SpriteMaterial")

      unless options.width? || options.height?
        options.width = options.height = 0

        options.material.image?.loaded.addOnce =>
          image = options.material.image
          @setHeight(2)
          @setWidth((image.getWidth() / image.getHeight())*@getHeight())

      super

