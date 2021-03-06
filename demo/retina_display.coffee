`module Two from "two"`

render = ->
  requestAnimationFrame(render)

  lowresRenderer.render(testImage, camera)
  highresRenderer.render(testImage, camera)

lowresCanvas = new Two.Canvas(width: 440, height: 300, devicePixelRatio: 1)
highresCanvas = new Two.Canvas(width: 440, height: 300, devicePixelRatio: 2)

lowresRenderer = new Two.SceneRenderer(
  backend: new Two.CanvasRenderer(canvas: lowresCanvas)
  backgroundColor: "grey")
highresRenderer = new Two.SceneRenderer(
  backend: new Two.CanvasRenderer(canvas: highresCanvas)
  backgroundColor: "grey")
camera = new Two.Camera(width: lowresCanvas.width, height: lowresCanvas.height)

lowresRenderer.backend.flipYAxis = highresRenderer.backend.flipYAxis = true

testImage = new Two.TransformNode()
testImage.add new Two.RenderNode(renderable: new Two.Sprite
  image: "/demo/assets/retina_tree.jpg"
  anchorPoint: [0, 1])
testImage.scale.setValues [0.5, 0.5]
testImage.position.setValues [20, lowresCanvas.height - 20]

document.body.appendChild(lowresCanvas.domElement)
document.body.appendChild(highresCanvas.domElement)

render()

