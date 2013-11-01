define ->
  class Camera
    constructor: (options) ->
      options ?= {}
      @aspectRatio = options.aspectRatio ?= 1
      @setWidth(options.width ?= 10)
      @x = @y = 0

    setWidth: (@_width) ->
      @_height = @_width / @aspectRatio

    getWidth: -> @_width
    getHeight: -> @_height
