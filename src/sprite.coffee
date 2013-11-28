define ["./box", "./sprite_material"], (Box, SpriteMaterial) ->
  class Sprite extends Box
    constructor: (options) ->
      unless options.material instanceof SpriteMaterial
        throw new Error("Material must be instance of SpriteMaterial")

      super

      unless options.name
        if @material.image?
          @setName "#{@material.image.getPath()} (#{@getId()})"
        else
          @setName "Sprite (#{@getId()})"

    clone: (overrides) ->
      new Sprite(@cloneProperties overrides)

