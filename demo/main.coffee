`module Two from "two"`

render = ->
  requestAnimationFrame(render)
  renderer.render()

canvas = new Two.Canvas(width: 640, height: 480)
renderer = new Two.SceneRenderer(canvas: canvas)
renderer.backend.imageSmoothingEnabled = false
document.body.appendChild(canvas.domElement)

root = new Two.Transform()
root.matrix = new Two.Matrix2d().translate(100, 100).rotate(0.5)

image = new Image()
image.src = "https://upload.wikimedia.org/wikipedia/en/6/65/Hello_logo_sm.gif"
sprite = new Two.Sprite(image: image)

root.add sprite


render()
