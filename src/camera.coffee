`import TransformNode from "./transform"`
`import Rectangle from "./rectangle"`
`import Vector2d from "./vector2d"`

Camera = TransformNode.extend
  initialize: ->
    @width = null
    @height = null
    @anchorPoint = [0, 0]

  getAABB: ->
    localTranslation = @_getLocalTranslation()
    worldMatrix = @worldMatrix

    position = new Vector2d([@position[0] + localTranslation[0], @position[1] - localTranslation[1]])

    # TODO: take rotation into account
    new Rectangle
      x: position[0] + worldMatrix[4]
      y: position[1] + worldMatrix[5]
      width: @width * worldMatrix[0]
      height: @width * worldMatrix[3]

  updateMatrix: ->
    TransformNode.prototype.updateMatrix.apply @

    localTranslation = @_getLocalTranslation()

    @_matrix
      .translate(localTranslation[0], localTranslation[1])
      .scale(@width, @height)

  _getLocalTranslation: ->
    [-@width*@anchorPoint[0], -@height*@anchorPoint[1]]

`export default Camera`

