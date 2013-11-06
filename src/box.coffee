define ["gl-matrix", "./material", "./object2d", "./utils", "./bounding_box", "./bounding_disc"], \
       (gl, Material, Object2d, Utils, BoundingBox, BoundingDisc) ->

  class Box extends Object2d
    constructor: (options={}) ->
      super options
      @width = options.width ?= 5
      @height = options.height ?= 5

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

    # Override these to provide different bounding box dimensions
    getBoundingWidth: -> @width
    getBoundingHeight: -> @height

    updateBoundingDisc: (disc) ->
      scale = @getScale()

      disc.setPosition @getPosition()
      disc.setRadius(
        gl.vec2.length(
          gl.vec2.fromValues(
            @getBoundingWidth()*scale/2, @getBoundingHeight()*scale/2)))

    updateBoundingBox: (box) ->
      box.setPosition @getPosition()
      box.setWidth @getScale()*@getBoundingWidth()
      box.setHeight @getScale()*@getBoundingHeight()

