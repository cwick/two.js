`module Two from "two"`

PROFILE_FREQUENCY = 2
profiler = Two.Profiler.create("frametime", PROFILE_FREQUENCY)
sampler = new Two.PeriodicSampler(PROFILE_FREQUENCY)

previousTime = 0
render = (time) ->
  requestAnimationFrame(render)

  for ball in balls
    x = ball.transform.position.x += ball.velocity[0]
    y = ball.transform.position.y += ball.velocity[1]
    if x > canvas.width || y > canvas.height || x < 0 || y < 0
      ball.velocity[0] *= -1
      ball.velocity[1] *= -1

  frameTime = profiler.collect(-> renderer.render(scene, camera)).toFixed(3)
  document.getElementById("frame-time").innerHTML = frameTime
  document.getElementById("fps").innerHTML = sampler.sample(1000 / (time - previousTime)).toFixed(2)
  previousTime = time

canvas = new Two.Canvas(width: 640, height: 480)
renderer = new Two.SceneRenderer(backend: new Two.CanvasRenderer(canvas: canvas))
camera = new Two.Camera(anchorPoint: [0,0], width: canvas.width, height: canvas.height)
loader = new Two.AssetLoader()
scene = new Two.TransformNode()

loader.preloadImage "Dream_Moon_Ball_Sprite", "/demo/assets/Dream_Moon_Ball_Sprite.png"

class Ball
  constructor: ->
    @transform = new Two.TransformNode()
    @velocity = [Math.random() - .5, Math.random() - .5]
    @velocity[0] *= 20
    @velocity[1] *= 20
    @transform.position = @getRandomPosition()
    @transform.add new Two.RenderNode(elements: [@ballSprite])

  ballSprite: new Two.Sprite
    image: loader.loadImage "Dream_Moon_Ball_Sprite"
    width: 40
    height: 40

  getRandomPosition: ->
    [
      Math.random() * (canvas.width - @ballSprite.width) + @ballSprite.width/2,
      Math.random() * (canvas.height - @ballSprite.height) + @ballSprite.height/2
    ]


balls = []
for x in [1..2000]
  ball = new Ball()
  balls.push ball

  scene.add ball.transform

document.getElementById("object-count").innerHTML = scene.children.length
document.body.appendChild(canvas.domElement)
render()

