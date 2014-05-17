`module Two from "two"`

render = ->
  requestAnimationFrame(render)
  renderer.render(scene)
  # spriteTransform.scale = Math.sin(Date.now() / 1000)
  spriteTransform.rotation += .01

canvas = new Two.Canvas(width: 640, height: 480)
renderer = new Two.SceneRenderer(canvas: canvas)

scene = new Two.TransformNode()
spriteTransform = new Two.TransformNode(position: [0,0])
sprite = new Two.Sprite
  image: "assets/blocks1.png"
  anchorPoint: [0, 0]

scene.add spriteTransform
spriteTransform.add sprite

document.body.appendChild(canvas.domElement)
render()

