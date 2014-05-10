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

render = ->
  requestAnimationFrame(render)

  for ball in balls
    x = ball.transform.position.x += ball.velocity[0]
    y = ball.transform.position.y += ball.velocity[1]
    if x > canvas.width || y > canvas.width || x < 0 || y < 0
      ball.velocity[0] *= -1
      ball.velocity[1] *= -1

  updateFPSCounter()
  renderer.render(root)
  updateFrameTime()

canvas = new Two.Canvas(width: 640, height: 480)
renderer = new Two.SceneRenderer(canvas: canvas)

root = new Two.TransformNode()

class Ball
  constructor: ->
    @transform = new Two.TransformNode()
    @velocity = [ Math.random() - .5, Math.random() - .5]
    @velocity[0] *= 20
    @velocity[1] *= 20
    @transform.position = @getRandomPosition()
    @transform.add @ballSprite.clone()

  ballSprite: new Two.Sprite
    image: "http://cdn.bulbagarden.net/upload/2/22/Dream_Moon_Ball_Sprite.png"
    width: 40
    height: 40
    origin: "center"

  getRandomPosition: ->
    [
      Math.random() * (canvas.width - @ballSprite.width) + @ballSprite.width/2,
      Math.random() * (canvas.height - @ballSprite.height) + @ballSprite.height/2
    ]


balls = []
for x in [1..6000]
  ball = new Ball()
  balls.push ball

  root.add ball.transform

document.getElementById("object-count").innerHTML = root.children.length
document.body.appendChild(canvas.domElement)
render()

