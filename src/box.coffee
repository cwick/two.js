define ["gl-matrix", "./shape", "./utils"], (gl, Shape, Utils) ->
  class Box extends Shape
    constructor: (options={}) ->
      super
      @width = options.width ?= 1
      @height = options.height ?= 1
      unless options.name
        @setName "Box (#{@getId()})"

    cloneProperties: (overrides) ->
      super Utils.merge(
        width: @width
        height: @height, overrides)

    clone: (overrides) ->
      new Box(@cloneProperties overrides)

    getWidth: -> @width
    getHeight: -> @height

    setWidth: (value) ->
      @width = value
      @invalidateBoundingGeometry()

    setHeight: (value) ->
      @height = value
      @invalidateBoundingGeometry()

    getBoundingWidth: -> @width
    getBoundingHeight: -> @height

