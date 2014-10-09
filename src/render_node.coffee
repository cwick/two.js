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

    @_getRenderCommand(worldMatrix, commands)

  _getWorldMatrix: (transform) ->
    [scaleX, scaleY] = @_scaleFromBounds()
    transform.scale(scaleX, scaleY)

  _getRenderCommand: (worldMatrix, commands) ->
    { name: "drawInReferenceFrame", referenceFrame: worldMatrix, commands: commands }

  _scaleFromBounds: ->
    scaleX = scaleY = 1
    bounds = @renderable.bounds

    if @width && bounds.width
      scaleX = @width / bounds.width
    if @height && bounds.height
      scaleY = @height / bounds.height

    [scaleX, scaleY]



`export default RenderNode`

