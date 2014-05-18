`module Two from "two"`

render = ->
  requestAnimationFrame(render)

  lowresRenderer.render(testImage, camera)
  highresRenderer.render(testImage, camera)

lowresCanvas = new Two.Canvas(width: 440, height: 300, devicePixelRatio: 1)
highresCanvas = new Two.Canvas(width: 440, height: 300, devicePixelRatio: 2)

lowresRenderer = new Two.SceneRenderer(canvas: lowresCanvas, backgroundColor: "grey")
highresRenderer = new Two.SceneRenderer(canvas: highresCanvas, backgroundColor: "grey")
camera = new Two.Camera(anchorPoint: [0,0], width: lowresCanvas.width, height: lowresCanvas.height)

testImage = new Two.TransformNode()
testImage.add new Two.RenderNode()
testImage.children[0].add new Two.Sprite
  image: "https://upload.wikimedia.org/wikipedia/en/7/7e/Person-tree.jpg"
  anchorPoint: [0, 1]
testImage.scale = 0.5
testImage.position = [20, lowresCanvas.height - 20]

document.body.appendChild(lowresCanvas.domElement)
document.body.appendChild(highresCanvas.domElement)

render()

