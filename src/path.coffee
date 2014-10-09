`import Renderable from "./renderable"`

Path = Renderable.extend
  initialize: ->
    @points = []

  generateRenderCommands: ->
    return {
      name: "drawPolygon"
      points: @points
    }

`export default Path`


