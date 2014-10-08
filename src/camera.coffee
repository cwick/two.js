`import TransformNode from "./transform_node"`
`import Size from "./size"`
`import Matrix2d from "./matrix2d"`

Camera = TransformNode.extend
  initialize: ->
    @width = null
    @height = null
    @anchorPoint = [0, 0]
    @viewport = new Size()
    @screenMatrix = new Matrix2d()

  updateMatrix: ->
    @super(TransformNode, "updateMatrix", arguments)

    localTranslation = @_getLocalTranslation()

    @_matrix
      .translate(localTranslation[0], localTranslation[1])
      .scale(@width, @height)

  updateScreenMatrix: ->
    @screenMatrix = @worldMatrix.clone()
      .scale(1/@viewport.width, 1/@viewport.height)
      .invert()

  _getLocalTranslation: ->
    [-@width*@anchorPoint[0], -@height*@anchorPoint[1]]

`export default Camera`

