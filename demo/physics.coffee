`module Two from "two"`

PROFILE_FREQUENCY = 2
timer = new Two.Timer()
profiler = Two.Profiler.create("frametime", PROFILE_FREQUENCY)
sampler = new Two.PeriodicSampler(PROFILE_FREQUENCY)

render = ->
  requestAnimationFrame(render)

  for ball in balls
    x = ball.transform.position.x += ball.velocity[0]
    y = ball.transform.position.y += ball.velocity[1]
    if x > canvas.width || y > canvas.height || x < 0 || y < 0
      ball.velocity[0] *= -1
      ball.velocity[1] *= -1

  frameTime = profiler.collect(-> renderer.render(root)).toFixed(3)
  document.getElementById("frame-time").innerHTML = frameTime
  document.getElementById("fps").innerHTML = sampler.sample(1000 / timer.mark()).toFixed(2)

canvas = new Two.Canvas(width: 640, height: 480)
renderer = new Two.SceneRenderer(canvas: canvas)

root = new Two.TransformNode()

Ball = Two.GameObject.extend Two.Components.Physics
  initialize: ->
    @physics.velocity.x = (Math.random() - .5) * 20
    @physics.velocity.y = (Math.random() - .5) * 20
    @transform.position = @getRandomPosition()
    @transform.add @ballSprite.clone()

  ballSprite:
    new Two.Sprite
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
for x in [1..2000]
  ball = new Ball()
  balls.push ball

  root.add ball.transform

document.body.appendChild(canvas.domElement)
render()


