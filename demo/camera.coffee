`module Two from "two"`

render = ->
  requestAnimationFrame(render)
  renderer.render(scene, camera)

  scale = 1/(.5*Math.sin(Date.now()/3000) + 2)
  camera.position.x += .5
  camera.scale.setValues [scale, scale]

canvas = new Two.Canvas(width: 640, height: 480)
renderer = new Two.SceneRenderer(backend: new Two.CanvasRenderer(canvas: canvas))
renderer.backend.flipYAxis = true

camera = new Two.Camera
  anchorPoint: [0.5, 0.5]
  position: new Two.Vector2d([0, 100])
  width: canvas.width,
  height: canvas.height
scene = new Two.TransformNode()
ground = new Two.TransformNode()
snail = new Two.TransformNode()
crab = new Two.TransformNode()

tileSize = 32
tileMargin = 2

characterSheet = new Image()
characterSheet.src = "assets/char1.png"

snailSprite = new Two.Sprite
  image: characterSheet
  anchorPoint: [0.5, 0]
  crop: new Two.Rectangle
    x: 398
    y: 362
    width: 34
    height: 34

crabSprite = snailSprite.clone()
crabSprite.crop = new Two.Rectangle
  x: 166
  y: 107
  width: 55
  height: 26

groundSprite = new Two.Sprite
  image: "assets/blocks1.png"
  anchorPoint: [0, 0]
  crop: new Two.Rectangle
    x: tileMargin + 2*(tileSize + tileMargin)
    y: tileMargin + 7*(tileSize + tileMargin)
    width: tileSize
    height: tileSize

for x in [0..40]
  tile = new Two.TransformNode(position: new Two.Vector2d([x*tileSize, 0]))
  tile.add new Two.RenderNode(renderable: groundSprite, width: tileSize, height: tileSize)
  ground.add tile

crab.position.setValues [tileSize*18, tileSize]
crab.add new Two.RenderNode(renderable: crabSprite, width: 55, height: 26)

snail.position.setValues [tileSize*10, tileSize]
snail.scale.setValues [-1,1]
snail.add new Two.RenderNode(renderable: snailSprite, width: 32, height: 32)

scene.add ground
scene.add snail
scene.add crab

document.body.appendChild(canvas.domElement)
render()

