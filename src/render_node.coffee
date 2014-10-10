`import SceneNode from "./scene_node"`
`import Renderable from "./renderable"`
`import Property from "./property"`

RenderNode = SceneNode.extend
  initialize: ->
    @renderable = new Renderable()
    @width = @height = null

  generateRenderCommand: (camera) ->
    commands = @renderable.generateRenderCommands(camera)
    worldMatrix = @_getWorldMatrix(@parent.worldMatrix.clone())
    worldMatrix.preMultiply camera.screenMatrix

    @_getRenderCommand(worldMatrix, commands)

  boundingBox: Property
    get: ->
      renderableBounds = @renderable.boundingBox
      [scaleX, scaleY] = @_scaleFromBounds(renderableBounds)
      renderableBounds.width *= scaleX
      renderableBounds.height *= scaleY
      renderableBounds.x *= scaleX
      renderableBounds.y *= scaleY
      renderableBounds

  _getWorldMatrix: (transform) ->
    [scaleX, scaleY] = @_scaleFromBounds(@renderable.boundingBox)
    transform.scale(scaleX, scaleY)

  _getRenderCommand: (worldMatrix, commands) ->
    { name: "drawInReferenceFrame", referenceFrame: worldMatrix, commands: commands }

  _scaleFromBounds: (bounds) ->
    scaleX = scaleY = 1

    if @width && bounds.width
      scaleX = @width / bounds.width
    if @height && bounds.height
      scaleY = @height / bounds.height

    [scaleX, scaleY]



`export default RenderNode`

