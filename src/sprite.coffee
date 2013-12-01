define ["./box", "./sprite_material"], (Box, SpriteMaterial) ->
  class Sprite extends Box
    constructor: (options) ->
      unless options.material instanceof SpriteMaterial
        throw new Error("Material must be instance of SpriteMaterial")

      super

      unless options.name
        if @getMaterial().image?
          @setName "#{@getMaterial().image.getPath()} (#{@getId()})"
        else
          @setName "Sprite (#{@getId()})"

    clone: (overrides) ->
      new Sprite(@cloneProperties overrides)

