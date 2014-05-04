`module Two from "two"`

render = ->
  requestAnimationFrame(render)
  renderer.render(root)

canvas = new Two.Canvas(width: 640, height: 480)
renderer = new Two.SceneRenderer(canvas: canvas)
renderer.backend.imageSmoothingEnabled = false

root = new Two.Transform()
root.matrix = new Two.Matrix2d().translate(100, 100).rotate(0.5)

helloImage = new Image()
helloImage.src = "https://upload.wikimedia.org/wikipedia/en/6/65/Hello_logo_sm.gif"
worldImage = new Image()
worldImage.src = "http://img.talkandroid.com/uploads/2012/08/World-300x305.jpg"

hello = new Two.Sprite(image: helloImage)
world = new Two.Sprite(image: worldImage)

worldTransform = new Two.Transform()
worldTransform.matrix = new Two.Matrix2d().translate(305, 0)

root.add hello
root.add worldTransform
worldTransform.add world

document.body.appendChild(canvas.domElement)
render()
