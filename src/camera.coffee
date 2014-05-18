`import TransformNode from "./transform"`

Camera = TransformNode.extend
  initialize: ->
    @width = null
    @height = null
    @anchorPoint = [0.5, 0.5]

  updateMatrix: ->
    @_super(TransformNode, "updateMatrix")()

    @_matrix
      .translate(-@width*@anchorPoint[0], -@height*@anchorPoint[1])
      .scale(@width, @height)


`export default Camera`

