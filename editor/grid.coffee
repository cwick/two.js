define ["two/line_group", "two/color", "two/line_material"], (LineGroup, Color, LineMaterial) ->
  class Grid extends LineGroup
    constructor: (options) ->
      vertices = []

      for x in [-100..100] by 1
        vertices.push [x, -100]
        vertices.push [x, 100]
      for y in [-100..100] by 1
        vertices.push [-100, y]
        vertices.push [100, y]

      super {
        vertices: vertices
        material: new LineMaterial(color: new Color(r: 0, g: 0, b: 0, a: 0.5))
      }

