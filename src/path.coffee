`import Renderable from "./renderable"`
`import Property from "./property"`
`import Rectangle from "./rectangle"`

Path = Renderable.extend
  initialize: ->
    @points = []

  generateRenderCommands: ->
    return {
      name: "drawPolygon"
      points: @points
    }

  boundingBox: Property
    get: ->
      minX = maxX = minY = maxY = 0
      for p in @points
        minX = Math.min(minX, p[0])
        maxX = Math.max(maxX, p[0])
        minY = Math.min(minY, p[1])
        maxY = Math.max(maxY, p[1])

      new Rectangle
        width: maxX - minX
        height: maxY - minY
        x: (minX + maxX) / 2
        y: (minY + maxY) / 2

`export default Path`


