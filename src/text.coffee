`import Renderable from "./renderable"`

Text = Renderable.extend
  clone: ->
    new Text
      text: @text
      fontSize: @fontSize

  generateRenderCommands: ->
    return {
      name: "drawText"
      text: if @text? then @text else ""
      fontSize: if @fontSize? then @fontSize else 12
      color: if @color? then @color else "white"
    }

`export default Text`

