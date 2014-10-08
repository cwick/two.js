`import TwoObject from "./object"`

Size = TwoObject.extend
  initialize: ->
    @width = @height = 1

  clone: ->
    new Size(width: @width, height: @height)

`export default Size`

