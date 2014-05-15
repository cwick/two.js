`import Shape from "./shape"`

Rectangle = Shape.extend
  initialize: ->
    @x = @y = @width = @height = 0

  clone: ->
    new Rectangle(x: @x, y: @y, width: @width, height: @height)

`export default Rectangle`

