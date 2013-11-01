define ->
  class Camera
    constructor: (options) ->
      options ?= {}
      @aspectRatio = options.aspectRatio ?= 1
      @width = options.width ?= 10
      @height = options.height ?= options.width / options.aspectRatio
      @x = @y = 0
