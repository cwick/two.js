define ["gl-matrix", "./shape", "./utils"], (gl, Shape, Utils) ->
  class Box extends Shape
    constructor: (options={}) ->
      super
      @_width = options.width ?= 1
      @_height = options.height ?= 1

      unless options.name
        @setName "Box (#{@getId()})"

    cloneProperties: (overrides) ->
      super Utils.merge(
        width: @_width
        height: @_height, overrides)

    clone: (overrides) ->
      new Box(@cloneProperties overrides)

    setSize: (width, height) ->
      @_width = width
      @_height = height

    getSize: ->
      [@_width, @_height]

    getWidth: -> @_width
    getHeight: -> @_height

    setWidth: (value) ->
      @_width = value
      @invalidateBoundingGeometry()

    setHeight: (value) ->
      @_height = value
      @invalidateBoundingGeometry()

    getBoundingWidth: -> @_width
    getBoundingHeight: -> @_height

