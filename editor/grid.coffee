define ["two/line_group", "two/color", "two/line_material"], (LineGroup, Color, LineMaterial) ->
  class Grid extends LineGroup
    constructor: (options) ->
      vertices = []

      for x in [-10..10] by 1
        vertices.push [x, -10]
        vertices.push [x, 10]
      for y in [-10..10] by 1
        vertices.push [-10, y]
        vertices.push [10, y]

      super {
        vertices: vertices
        material: new LineMaterial(color: new Color(r: 0, g: 0, b: 0, a: 0.5))
      }

