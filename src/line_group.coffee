define ["./line_material", "./object2d"], (LineMaterial, Object2d) ->
  class LineGroup extends Object2d
    constructor: (options) ->
      unless options.material instanceof LineMaterial
        throw new Error("Material must be instance of LineMaterial")

      @_vertices = options.vertices ?= []
      super

    getVertices: -> @_vertices
    setVertices: (value) -> @_vertices = value



