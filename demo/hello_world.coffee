`module Two from "two"`

render = ->
  requestAnimationFrame(render)
  helloWorldTransform.rotation += 0.008
  wobble.position.x = Math.sin(Date.now() / 500) * 100
  renderer.render(scene)

canvas = new Two.Canvas(width: 640, height: 480)
renderer = new Two.SceneRenderer(canvas: canvas)

scene = new Two.TransformNode()
wobble = new Two.TransformNode()
helloWorldTransform = new Two.TransformNode()
worldTransform = new Two.TransformNode()
helloTransform = new Two.TransformNode()

helloWorldTransform.position = [320, 240]
helloWorldTransform.scale = .5

helloTransform.add new Two.RenderNode()
helloTransform.children[0].add new Two.Sprite
  image: "https://upload.wikimedia.org/wikipedia/en/6/65/Hello_logo_sm.gif"
  anchorPoint: [0, 1]
worldTransform.add new Two.RenderNode()
worldTransform.children[0].add new Two.Sprite
  image: "http://img.talkandroid.com/uploads/2012/08/World-300x305.jpg"
  anchorPoint: [0, 1]

helloTransform.position = [-305, 150]
worldTransform.position = [0, 150]

scene.add wobble

wobble.add helloWorldTransform
helloWorldTransform.add helloTransform
helloWorldTransform.add worldTransform

document.body.appendChild(canvas.domElement)
render()
