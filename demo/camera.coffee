`module Two from "two"`

render = ->
  requestAnimationFrame(render)
  renderer.render(scene)

canvas = new Two.Canvas(width: 640, height: 480)
renderer = new Two.SceneRenderer(canvas: canvas)
renderer.backend.imageSmoothingEnabled = false

scene = new Two.TransformNode()
ground = new Two.TransformNode()

tileSize = 32
tileMargin = 2

sprite = new Two.Sprite
  image: "assets/blocks1.png"
  anchorPoint: [0, 0]
  width: tileSize
  height: tileSize
  crop: new Two.Rectangle
    x: tileMargin + 2*(tileSize + tileMargin)
    y: tileMargin + 7*(tileSize + tileMargin)
    width: tileSize
    height: tileSize

for x in [0..40]
  tile = new Two.TransformNode(position: [x*tileSize, 0])
  tile.add new Two.RenderNode(components: [sprite])
  ground.add tile

scene.add ground

document.body.appendChild(canvas.domElement)
render()

