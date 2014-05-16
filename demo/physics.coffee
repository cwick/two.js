`module Two from "two"`

PROFILE_FREQUENCY = 2
BALL_COUNT = 15*15
timer = new Two.Timer()
renderProfiler = Two.Profiler.create("render", PROFILE_FREQUENCY)
physicsProfiler = Two.Profiler.create("physics", PROFILE_FREQUENCY)
sampler = new Two.PeriodicSampler(PROFILE_FREQUENCY)

render = ->
  requestAnimationFrame(render)

  renderTime = renderProfiler.collect(-> renderer.render(scene)).toFixed(3)
  physicsTime = physicsProfiler.collect(-> world.step(1/60)).toFixed(3)

  document.getElementById("render-time").innerHTML = renderTime
  document.getElementById("physics-time").innerHTML = physicsTime
  document.getElementById("fps").innerHTML = sampler.sample(1000 / timer.mark()).toFixed(2)

canvas = new Two.Canvas(width: 640, height: 480)
renderer = new Two.SceneRenderer(canvas: canvas)

scene = new Two.TransformNode()

Ball = Two.GameObject.extend Two.Components.Physics,
  initialize: ->
    @physics.velocity.x = (Math.random() - .5) * 100
    @physics.velocity.y = (Math.random() - .5) * 100
    @physics.shape = new Two.Circle(radius: @ballSprite.width/2)
    @transform.position = @getRandomPosition()
    @transform.add @ballSprite.clone()

  ballSprite:
    new Two.Sprite
      image: "http://cdn.bulbagarden.net/upload/2/22/Dream_Moon_Ball_Sprite.png"
      width: 20
      height: 20
      origin: "center"
      crop: new Two.Rectangle
        x: 10
        y: 10
        width: 60
        height: 60

  getRandomPosition: ->
    [
      Math.random() * (canvas.width - @ballSprite.width) + @ballSprite.width/2,
      Math.random() * (canvas.height - @ballSprite.height) + @ballSprite.height/2
    ]


world = new Two.GameWorld()
world.physics.gravity = 0

for x in [1..BALL_COUNT]
  ball = new Ball()

  scene.add ball.transform
  world.add ball

Boundary = Two.GameObject.extend Two.Components.Physics,
  initialize: (options) ->
    switch options.type
      when "bottom"
        @transform.position.y = canvas.height
        @transform.rotation = Math.PI
      when "left"
        @transform.rotation = -Math.PI/2
      when "right"
        @transform.rotation = Math.PI/2
        @transform.position.x = canvas.width

    @physics.shape = new Two.Plane()
    @physics.type = "static"

world.add new Boundary(type: "bottom")
world.add new Boundary(type: "top")
world.add new Boundary(type: "left")
world.add new Boundary(type: "right")

document.body.appendChild(canvas.domElement)
render()


