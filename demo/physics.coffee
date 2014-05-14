`module Two from "two"`

PROFILE_FREQUENCY = 2
BALL_COUNT = 2000
timer = new Two.Timer()
renderProfiler = Two.Profiler.create("render", PROFILE_FREQUENCY)
physicsProfiler = Two.Profiler.create("physics", PROFILE_FREQUENCY)
sampler = new Two.PeriodicSampler(PROFILE_FREQUENCY)

render = ->
  requestAnimationFrame(render)

  renderTime = renderProfiler.collect(-> renderer.render(root)).toFixed(3)
  physicsTime = physicsProfiler.collect(-> world.step(1/60)).toFixed(3)

  document.getElementById("render-time").innerHTML = renderTime
  document.getElementById("physics-time").innerHTML = physicsTime
  document.getElementById("fps").innerHTML = sampler.sample(1000 / timer.mark()).toFixed(2)

canvas = new Two.Canvas(width: 640, height: 480)
renderer = new Two.SceneRenderer(canvas: canvas)

root = new Two.TransformNode()

Ball = Two.GameObject.extend Two.Components.Physics,
  initialize: ->
    @physics.velocity.x = (Math.random() - .5) * 100
    @physics.velocity.y = (Math.random() - .5) * 100
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


world = new Two.GameWorld()
world.physics.gravity = 0

for x in [1..BALL_COUNT]
  ball = new Ball()

  root.add ball.transform
  world.add ball

document.body.appendChild(canvas.domElement)
render()


