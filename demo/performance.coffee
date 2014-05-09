`module Two from "two"`

previousTimestamp = Date.now()
counter = 0

updateFPSCounter = ->
  counter += 1
  timestamp = Date.now()
  if counter == 30
    document.getElementById("fps").innerHTML = Math.round(1000 / (timestamp - previousTimestamp))
    counter = 0
  previousTimestamp = timestamp

updateFrameTime = ->
  timestamp = Date.now()
  if counter == 29
    document.getElementById("frame-time").innerHTML = timestamp - previousTimestamp

getRandomPosition = ->
  [
    Math.random() * (canvas.width - ballSprite.width) + ballSprite.width/2,
    Math.random() * (canvas.height - ballSprite.height) + ballSprite.height/2
  ]

render = ->
  requestAnimationFrame(render)

  updateFPSCounter()
  renderer.render(root)
  updateFrameTime()

canvas = new Two.Canvas(width: 640, height: 480)
renderer = new Two.SceneRenderer(canvas: canvas)

root = new Two.TransformNode()

ballSprite = new Two.Sprite
  image: "http://www.clker.com/cliparts/r/y/Z/3/u/a/ball-hi.png"
  width: 40
  height: 40
  origin: "center"

for x in [1..2000]
  ball = new Two.TransformNode()
  ball.position = getRandomPosition()
  ball.add ballSprite.clone()

  root.add ball

document.getElementById("object-count").innerHTML = root.children.length
document.body.appendChild(canvas.domElement)
render()

