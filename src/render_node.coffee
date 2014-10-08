`import SceneNode from "./scene_node"`
`import Renderable from "./renderable"`
`import Property from "./property"`

RenderNode = SceneNode.extend
  initialize: ->
    @renderable = new Renderable()
    @width = @height = null

  generateRenderCommands: (camera) ->
    commands = @renderable.generateRenderCommands(camera)
    worldMatrix = @_getWorldMatrix(@parent.worldMatrix.clone())
    worldMatrix.preMultiply camera.screenMatrix

    transformCommand = @_getTransformCommand(worldMatrix)

    [ transformCommand, commands ]

  _getWorldMatrix: (transform) ->
    [scaleX, scaleY] = @_scaleFromBounds()
    transform.scale(scaleX, scaleY)

  _getTransformCommand: (worldMatrix) ->
    { name: "setTransform", matrix: worldMatrix }

  _scaleFromBounds: ->
    scaleX = scaleY = 1
    bounds = @renderable.bounds

    if @width && bounds.width
      scaleX = @width / bounds.width
    if @height && bounds.height
      scaleY = @height / bounds.height

    [scaleX, scaleY]



`export default RenderNode`

