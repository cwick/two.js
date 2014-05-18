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

  renderTime = renderProfiler.collect(-> renderer.render(scene, camera)).toFixed(3)
  physicsTime = physicsProfiler.collect(-> world.step(1/60)).toFixed(3)

  document.getElementById("render-time").innerHTML = renderTime
  document.getElementById("physics-time").innerHTML = physicsTime
  document.getElementById("fps").innerHTML = sampler.sample(1000 / timer.mark()).toFixed(2)

canvas = new Two.Canvas(width: 640, height: 480)
renderer = new Two.SceneRenderer(canvas: canvas)
camera = new Two.Camera(anchorPoint: [0,0], width: canvas.width, height: canvas.height)
scene = new Two.TransformNode()

Ball = Two.GameObject.extend Two.Components.P2Physics,
  initialize: ->
    @physics.motionState = p2.Body.DYNAMIC
    @physics.mass = 1
    @physics.velocity[0] = (Math.random() - .5) * 300
    @physics.velocity[1] = Math.random() * - 400 + 100
    @physics.angularVelocity = (Math.random() - .5) * 2*Math.PI
    @physics.addShape new p2.Circle(@ballSprite.width/2)
    @physics.position = @getRandomPosition()
    @physics.updateMassProperties()
    @transform.add new Two.RenderNode(components: [@ballSprite])

  ballSprite:
    new Two.Sprite
      image: "https://upload.wikimedia.org/wikipedia/en/thumb/e/ec/Soccer_ball.svg/480px-Soccer_ball.svg.png"
      width: 20
      height: 20
      crop: new Two.Rectangle
        x: 5
        y: 5
        width: 470
        height: 470

  getRandomPosition: ->
    [
      Math.random() * (canvas.width - @ballSprite.width) + @ballSprite.width/2,
      Math.random() * (canvas.height - @ballSprite.height) + @ballSprite.height/2
    ]


world = new Two.GameWorld()
world.physics.p2.gravity = [0, -920]
world.physics.p2.defaultContactMaterial.restitution = .55
world.physics.p2.defaultContactMaterial.stiffness = Number.MAX_VALUE

for x in [1..BALL_COUNT]
  ball = new Ball()

  scene.add ball.transform
  world.add ball

Boundary = Two.GameObject.extend Two.Components.P2Physics,
  initialize: (options) ->
    plane = new p2.Plane()

    switch options.type
      when "bottom"
        @physics.position[1] = canvas.height
        @physics.angle = Math.PI
      when "left"
        @physics.angle = -Math.PI/2
      when "right"
        @physics.angle = Math.PI/2
        @physics.position[0] = canvas.width

    @physics.addShape(plane)

world.add new Boundary(type: "bottom")
world.add new Boundary(type: "top")
world.add new Boundary(type: "left")
world.add new Boundary(type: "right")

document.body.appendChild(canvas.domElement)
render()


