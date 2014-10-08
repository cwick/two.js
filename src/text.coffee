`import TwoObject from "./object"`

Text = TwoObject.extend
  clone: ->
    new Text
      text: @text
      fontSize: @fontSize

  generateRenderCommands: (transform) ->
    return {
      name: "drawText"
      transform: transform
      text: if @text? then @text else ""
      fontSize: if @fontSize? then @fontSize else 12
      color: if @color? then @color else "white"
    }

`export default Text`

