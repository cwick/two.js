define ["two/line_group", "two/color", "two/line_material"], (LineGroup, Color, LineMaterial) ->
  class Grid extends LineGroup
    constructor: ->
      super
        material: new LineMaterial(color: new Color(r: 0, g: 0, b: 0, a: 0.5))

      @_horizontalSize = 1
      @_verticalSize = 1
      @_horizontalCells = 20
      @_verticalCells = 20
      @build()

    setHorizontalSize: (value) ->
      @_horizontalSize = value

    getHorizontalSize: ->
      @_horizontalSize

    setVerticalSize: (value) ->
      @_verticalSize = value

    getVerticalSize: ->
      @_verticalSize

    setHorizontalCells: (value) ->
      @_horizontalCells = value

    setVerticalCells: (value) ->
      @_verticalCells = value

    getWidth: -> @_horizontalCells * @_horizontalSize
    getHeight: -> @_verticalCells * @_verticalSize

    build: ->
      vertices = []

      maxX = @getWidth()/2
      maxY = @getHeight()/2
      minX = -maxX
      minY = -maxY
      horizontalStep = @_horizontalSize
      verticalStep = @_verticalSize

      for x in [minX..maxX] by horizontalStep
        vertices.push [x, minY]
        vertices.push [x, maxY]
      for y in [minY..maxY] by verticalStep
        vertices.push [minX, y]
        vertices.push [maxX, y]

      @setVertices vertices

