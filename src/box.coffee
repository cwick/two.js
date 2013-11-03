define ["gl-matrix", "./material", "./object2d", "./utils", "./bounding_box", "./bounding_disc"], \
       (gl, Material, Object2d, Utils, BoundingBox, BoundingDisc) ->

  class Box extends Object2d
    constructor: (options={}) ->
      super options
      @width = options.width ?= 5
      @height = options.height ?= 5

    _createBoundingDisc: ->
      new BoundingDisc(x: @x, y: @y, radius: gl.vec2.length(gl.vec2.fromValues(@width/2, @height/2)))

    _createBoundingBox: ->
      new BoundingBox(x: @x, y: @y, width: @width, height: @height)

    clone: (overrides) ->
      new Box(@cloneProperties Utils.merge(
        width: @width
        height: @height, overrides))

