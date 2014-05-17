`module Two from "two"`

simulationSpeed = .1

window.setSimulationSpeed = ->
  simulationSpeed = document.getElementById("simulation-speed").value / 1000

render = ->
  requestAnimationFrame(render)
  renderer.render(root)

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
renderer = new Two.SceneRenderer(canvas: canvas)
root = new Two.TransformNode()

root.position = [400, 400]

EARTH_PERIOD = 365
EARTH_DAY_LENGTH = 1
MERCURY_PERIOD = 88
MERCURY_DAY_LENGTH = 58
VENUS_PERIOD = 225
VENUS_DAY_LENGTH = 243
MARS_PERIOD = 687
MARS_DAY_LENGTH = 1

sun = new Two.Sprite
  image: "http://music.ckut.ca/wp-content/uploads/2011/09/sun-solar-flare.jpg"
  width: 100
  height: 100

mercury = new Two.Sprite
  image: "http://tallbloke.files.wordpress.com/2012/02/mercury-300x300.jpg"
  width: 20
  height: 20

venus = new Two.Sprite
  image: "https://d1jqu7g1y74ds1.cloudfront.net/wp-content/uploads/2009/08/venusmagellan.jpg"
  width: 60
  height: 60

earth = new Two.Sprite
  image: "http://img3.wikia.nocookie.net/__cb20100221225734/uncyclopedia/images/d/d0/Earth.PNG"
  width: 50
  height: 50

moon = new Two.Sprite
  image: "http://www.howitworksdaily.com/wp-content/uploads/2012/12/Moon.jpg"
  width: 20
  height: 20

mars = new Two.Sprite
  image: "http://schoolofartgalleries.dsc.rmit.edu.au/PSSR/exhibitions/2008/the_mars_project/mars0_lth.jpg"
  width: 30
  height: 30

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

root.add sunTransform
sunTransform.add sun
sunTransform.add earthOrbit
sunTransform.add mercuryOrbit
sunTransform.add venusOrbit
sunTransform.add marsOrbit

document.body.appendChild(canvas.domElement)
render()
