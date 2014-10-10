`import Renderable from "./renderable"`
`import Property from "./property"`
`import Size from "./size"`

Path = Renderable.extend
  initialize: ->
    @points = []

  generateRenderCommands: ->
    return {
      name: "drawPolygon"
      points: @points
    }


  bounds: Property
    get: ->
      minX = maxX = minY = maxY = 0
      for p in @points
        minX = Math.min(minX, p[0])
        maxX = Math.max(maxX, p[0])
        minY = Math.min(minY, p[1])
        maxY = Math.max(maxY, p[1])

      new Size(width: maxX - minX, height: maxY - minY)

`export default Path`


