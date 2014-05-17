`module Two from "two"`

render = ->
  requestAnimationFrame(render)

  lowresRenderer.render(testImage)
  highresRenderer.render(testImage)

lowresCanvas = new Two.Canvas(width: 440, height: 300, devicePixelRatio: 1)
highresCanvas = new Two.Canvas(width: 440, height: 300, devicePixelRatio: 2)

lowresRenderer = new Two.SceneRenderer(canvas: lowresCanvas)
highresRenderer = new Two.SceneRenderer(canvas: highresCanvas)

testImage = new Two.TransformNode()
testImage.add new Two.Sprite
  image: "https://upload.wikimedia.org/wikipedia/en/7/7e/Person-tree.jpg"
  anchorPoint: [0, 1]
testImage.scale = 0.5
testImage.position = [20, 20]

document.body.appendChild(lowresCanvas.domElement)
document.body.appendChild(highresCanvas.domElement)

render()

