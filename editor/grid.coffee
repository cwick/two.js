define ["two/line_group", "two/color", "two/line_material"], (LineGroup, Color, LineMaterial) ->
  class Grid extends LineGroup
    constructor: (options) ->
      super {
        vertices: [ [0,0], [10,0] ]
        material: new LineMaterial(color: new Color(r: 0, g: 0, b: 0, a: 0.5))
      }

