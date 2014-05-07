`module Two from "two"`

render = ->
  requestAnimationFrame(render)
  objectTransform.rotation += 0.008
  wobble.position.x = Math.sin(Date.now() / 500) * 100
  renderer.render(root)

canvas = new Two.Canvas(width: 640, height: 480)
renderer = new Two.SceneRenderer(canvas: canvas)
renderer.backend.imageSmoothingEnabled = false

root = new Two.TransformNode()
wobble = new Two.TransformNode()
objectTransform = new Two.TransformNode()
worldSpriteTransform = new Two.TransformNode()

objectTransform.position = [320, 240]
objectTransform.origin = [302,150]
objectTransform.scale = .5

helloImage = new Image()
helloImage.src = "https://upload.wikimedia.org/wikipedia/en/6/65/Hello_logo_sm.gif"
worldImage = new Image()
worldImage.src = "http://img.talkandroid.com/uploads/2012/08/World-300x305.jpg"

helloSprite = new Two.Sprite(image: helloImage)
worldSprite = new Two.Sprite(image: worldImage)

worldSpriteTransform.position = [305, 0]

root.add wobble

wobble.add objectTransform
objectTransform.add helloSprite
objectTransform.add worldSpriteTransform
worldSpriteTransform.add worldSprite

document.body.appendChild(canvas.domElement)
render()
