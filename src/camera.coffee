`import TransformNode from "./transform"`

Camera = TransformNode.extend
  initialize: ->
    @_super(TransformNode, "initialize")()
    @width = 1
    @height = 1
    @anchorPoint = [0.5, 0.5]

  updateMatrix: ->
    @_super(TransformNode, "updateMatrix")()

    @_matrix
      .translate(-@width*@anchorPoint[0], -@height*@anchorPoint[1])
      .scale(@width, @height)


`export default Camera`

