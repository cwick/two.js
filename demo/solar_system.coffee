`module Two from "two"`

simulationSpeed = .1

window.setSimulationSpeed = ->
  simulationSpeed = document.getElementById("simulation-speed").value / 1000

render = ->
  requestAnimationFrame(render)
  renderer.render(scene, camera)

  mercuryOrbitSpeed = simulationSpeed / MERCURY_PERIOD
  earthOrbitSpeed = simulationSpeed / EARTH_PERIOD
  venusOrbitSpeed = simulationSpeed / VENUS_PERIOD
  marsOrbitSpeed = simulationSpeed / MARS_PERIOD

  earthOrbit.rotation -= earthOrbitSpeed
  earthTransform.rotation += earthOrbitSpeed * (1 - EARTH_PERIOD / EARTH_DAY_LENGTH)

  mercuryOrbit.rotation -= mercuryOrbitSpeed
  mercuryTransform.rotation += mercuryOrbitSpeed * (1 - MERCURY_PERIOD / MERCURY_DAY_LENGTH)

  venusOrbit.rotation -= venusOrbitSpeed
  # Venus rotates backwards!
  venusTransform.rotation += venusOrbitSpeed * (1 + VENUS_PERIOD / VENUS_DAY_LENGTH)

  marsOrbit.rotation -= marsOrbitSpeed
  marsTransform.rotation += marsOrbitSpeed * (1 - MARS_PERIOD / MARS_DAY_LENGTH)

canvas = new Two.Canvas(width: 800, height: 800)
renderer = new Two.SceneRenderer(backend: new Two.CanvasRenderer(canvas: canvas))
scene = new Two.TransformNode()
camera = new Two.Camera(width: canvas.width, height: canvas.height, anchorPoint: [0.5, 0.5])

EARTH_PERIOD = 365
EARTH_DAY_LENGTH = 1
MERCURY_PERIOD = 88
MERCURY_DAY_LENGTH = 58
VENUS_PERIOD = 225
VENUS_DAY_LENGTH = 243
MARS_PERIOD = 687
MARS_DAY_LENGTH = 1

sun = new Two.RenderNode(renderable: new Two.Sprite
  image: "/demo/assets/sun.jpg"
  width: 200
  height: 200)

mercury = new Two.RenderNode(renderable: new Two.Sprite
  image: "/demo/assets/mercury.jpg"
  width: 20
  height: 20)

venus = new Two.RenderNode(renderable: new Two.Sprite
  image: "/demo/assets/venus.jpg"
  width: 60
  height: 60)

earth = new Two.RenderNode(renderable: new Two.Sprite
  image: "/demo/assets/earth.png"
  width: 50
  height: 50)

moon = new Two.RenderNode(renderable: new Two.Sprite
  image: "/demo/assets/moon.jpg"
  width: 20
  height: 20)

mars = new Two.RenderNode(renderable: new Two.Sprite
  image: "/demo/assets/mars.jpg"
  width: 30
  height: 30)

earthTransform = new Two.TransformNode()
sunTransform = new Two.TransformNode()
moonTransform = new Two.TransformNode()
mercuryTransform = new Two.TransformNode()
venusTransform = new Two.TransformNode()
marsTransform = new Two.TransformNode()

mercuryOrbit = new Two.TransformNode()
earthOrbit = new Two.TransformNode()
moonOrbit = new Two.TransformNode()
venusOrbit = new Two.TransformNode()
marsOrbit = new Two.TransformNode()

earthOrbit.add earthTransform
moonOrbit.add moonTransform
mercuryOrbit.add mercuryTransform
venusOrbit.add venusTransform
marsOrbit.add marsTransform

# Set the orbital radius
earthTransform.position.x = 250
moonTransform.position.x = 50
mercuryTransform.position.x = 100
venusTransform.position.x = 160
marsTransform.position.x = 350

earthTransform.add earth
earthTransform.add moonOrbit
moonTransform.add moon
mercuryTransform.add mercury
venusTransform.add venus
marsTransform.add mars

scene.add sunTransform
sunTransform.add sun
sunTransform.add earthOrbit
sunTransform.add mercuryOrbit
sunTransform.add venusOrbit
sunTransform.add marsOrbit

document.body.appendChild(canvas.domElement)
render()
