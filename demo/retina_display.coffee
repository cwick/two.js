`module Two from "two"`

render = ->
  requestAnimationFrame(render)

  lowresRenderer.renderdemo/retina_display.coffee
  highresRenderer.render(testImage)

makeImage = (src) ->
  image  = new Image()
  image.src = src
  image

lowresCanvas = new Two.Canvas(width: 440, height: 300, devicePixelRatio: 1)
highresCanvas = new Two.Canvas(width: 440, height: 300, devicePixelRatio: 2)

lowresRenderer = new Two.SceneRenderer(canvas: lowresCanvas)
highresRenderer = new Two.SceneRenderer(canvas: highresCanvas)

testImage = new Two.TransformNode()
testImage.add new Two.Sprite(image: makeImage("https://upload.wikimedia.org/wikipedia/en/7/7e/Person-tree.jpg"))
testImage.scale = 0.5
testImage.position = [20, 20]

document.body.appendChild(lowresCanvas.domElement)
document.body.appendChild(highresCanvas.domElement)

render()

