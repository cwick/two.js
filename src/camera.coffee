`import TransformNode from "./transform"`

Camera = TransformNode.extend
  initialize: ->
    @width = null
    @height = null
    @anchorPoint = [0, 0]

  updateMatrix: ->
    TransformNode.prototype.updateMatrix.apply @

    @_matrix
      .translate(-@width*@anchorPoint[0], -@height*@anchorPoint[1])
      .scale(@width, @height)


`export default Camera`

