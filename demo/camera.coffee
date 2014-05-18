`module Two from "two"`

render = ->
  requestAnimationFrame(render)
  renderer.render(scene)

  scale = .5*Math.sin(Date.now()/3000) + 2
  scene.position.x -= .5
  scene.scale = scale

canvas = new Two.Canvas(width: 640, height: 480)
renderer = new Two.SceneRenderer(canvas: canvas)
renderer.backend.imageSmoothingEnabled = false

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
  width: 32
  height: 32
  crop: new Two.Rectangle
    x: 398
    y: 362
    width: 34
    height: 34

crabSprite = snailSprite.clone()
crabSprite.width = 55
crabSprite.height = 26
crabSprite.crop = new Two.Rectangle
  x: 166
  y: 107
  width: 55
  height: 26

groundSprite = new Two.Sprite
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
  tile.add groundSprite.clone()
  ground.add tile

crab.position = [tileSize*18, tileSize]
crab.add crabSprite

snail.position = [tileSize*10, tileSize]
snail.scale = [-1,1]
snail.add snailSprite

scene.add ground
scene.add snail
scene.add crab

document.body.appendChild(canvas.domElement)
render()

