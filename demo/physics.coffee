`module Two from "two"`
`module p2 from "lib/p2"`

PROFILE_FREQUENCY = 2
BALL_COUNT = 15*10
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

Ball = Two.GameObject.extend Two.Components.RigidBody,
  initialize: ->
    @rigidBody.motionState = p2.Body.DYNAMIC
    @rigidBody.mass = 1
    @rigidBody.velocity[0] = (Math.random() - .5) * 300
    @rigidBody.velocity[1] = Math.random() * - 400 + 100
    @rigidBody.angularVelocity = (Math.random() - .5) * 2*Math.PI
    @rigidBody.addShape new p2.Circle(@ballSprite.width/2)
    @rigidBody.position = @getRandomPosition()
    @rigidBody.updateMassProperties()
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
world.physics.p2.gravity = [0, 920]
world.physics.p2.defaultContactMaterial.restitution = .55
world.physics.p2.defaultContactMaterial.stiffness = Number.MAX_VALUE

for x in [1..BALL_COUNT]
  ball = new Ball()

  scene.add ball.transform
  world.add ball

Boundary = Two.GameObject.extend Two.Components.RigidBody,
  initialize: (options) ->
    plane = new p2.Plane()

    switch options.type
      when "bottom"
        @rigidBody.position[1] = canvas.height
        @rigidBody.angle = Math.PI
      when "left"
        @rigidBody.angle = -Math.PI/2
      when "right"
        @rigidBody.angle = Math.PI/2
        @rigidBody.position[0] = canvas.width

    @rigidBody.addShape(plane)

world.add new Boundary(type: "bottom")
world.add new Boundary(type: "top")
world.add new Boundary(type: "left")
world.add new Boundary(type: "right")

document.body.appendChild(canvas.domElement)
render()


