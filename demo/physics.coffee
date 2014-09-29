`module Two from "two"`
`module p2 from "lib/p2"`

PROFILE_FREQUENCY = 2
BALL_COUNT = 15*10
timer = new Two.Timer()
sampler = new Two.PeriodicSampler(PROFILE_FREQUENCY)

render = ->
  requestAnimationFrame(render)

  renderTime = sampler.sample(Two.Profiler.measure(-> renderer.render(scene, camera)), "renderTime")
  physicsTime = sampler.sample(Two.Profiler.measure(-> world.tick(1/60)), "physicsTime")

  document.getElementById("render-time").innerHTML = renderTime
  document.getElementById("physics-time").innerHTML = physicsTime
  document.getElementById("fps").innerHTML = sampler.sample(1000 / timer.mark()).toFixed(2)

canvas = new Two.Canvas(width: 640, height: 480)
renderer = new Two.SceneRenderer(backend: new Two.CanvasRenderer(canvas: canvas))
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
    @transform.add new Two.RenderNode(elements: [@ballSprite])

  ballSprite:
    new Two.Sprite
      image: "/demo/assets/soccer_ball.png"
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
world.physics.p2.world.gravity = [0, -920]
world.physics.p2.world.defaultContactMaterial.restitution = .55
world.physics.p2.world.defaultContactMaterial.stiffness = Number.MAX_VALUE

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


