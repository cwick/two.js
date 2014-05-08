`module Two from "two"`

render = ->
  requestAnimationFrame(render)
  renderer.render(root)

  earthOrbit.rotation -= EARTH_ORBIT_SPEED
  earthTransform.rotation += EARTH_ORBIT_SPEED * (1 - EARTH_PERIOD / EARTH_DAY_LENGTH)

  mercuryOrbit.rotation -= MERCURY_ORBIT_SPEED
  mercuryTransform.rotation += MERCURY_ORBIT_SPEED * (1 - MERCURY_PERIOD / MERCURY_DAY_LENGTH)

  venusOrbit.rotation -= VENUS_ORBIT_SPEED
  # Venus rotates backwards!
  venusTransform.rotation += VENUS_ORBIT_SPEED * (1 + VENUS_PERIOD / VENUS_DAY_LENGTH)

canvas = new Two.Canvas(width: 800, height: 600)
renderer = new Two.SceneRenderer(canvas: canvas)
root = new Two.TransformNode()

root.position = [400, 300]

SIMULATION_SPEED = .08
EARTH_PERIOD = 365
EARTH_DAY_LENGTH = 1
MERCURY_PERIOD = 88
MERCURY_DAY_LENGTH = 58
VENUS_PERIOD = 225
VENUS_DAY_LENGTH = 243

MERCURY_ORBIT_SPEED = SIMULATION_SPEED / MERCURY_PERIOD
EARTH_ORBIT_SPEED = SIMULATION_SPEED / EARTH_PERIOD
VENUS_ORBIT_SPEED = SIMULATION_SPEED / VENUS_PERIOD

sun = new Two.Sprite
  image: "http://music.ckut.ca/wp-content/uploads/2011/09/sun-solar-flare.jpg"
  width: 100
  height: 100
  origin: "center"

mercury = new Two.Sprite
  image: "http://tallbloke.files.wordpress.com/2012/02/mercury-300x300.jpg"
  width: 20
  height: 20
  origin: "center"

venus = new Two.Sprite
  image: "https://d1jqu7g1y74ds1.cloudfront.net/wp-content/uploads/2009/08/venusmagellan.jpg"
  width: 60
  height: 60
  origin: "center"

earth = new Two.Sprite
  image: "http://img3.wikia.nocookie.net/__cb20100221225734/uncyclopedia/images/d/d0/Earth.PNG"
  width: 50
  height: 50
  origin: "center"

moon = new Two.Sprite
  image: "http://www.howitworksdaily.com/wp-content/uploads/2012/12/Moon.jpg"
  width: 20
  height: 20
  origin: "center"

earthTransform = new Two.TransformNode()
sunTransform = new Two.TransformNode()
moonTransform = new Two.TransformNode()
mercuryTransform = new Two.TransformNode()
venusTransform = new Two.TransformNode()

mercuryOrbit = new Two.TransformNode()
earthOrbit = new Two.TransformNode()
moonOrbit = new Two.TransformNode()
venusOrbit = new Two.TransformNode()

earthOrbit.add earthTransform
moonOrbit.add moonTransform
mercuryOrbit.add mercuryTransform
venusOrbit.add venusTransform

# Set the orbital radius
earthTransform.position.x = 250
moonTransform.position.x = 50
mercuryTransform.position.x = 100
venusTransform.position.x = 160

earthTransform.add earth
earthTransform.add moonOrbit
moonTransform.add moon
mercuryTransform.add mercury
venusTransform.add venus


root.add sunTransform
sunTransform.add sun
sunTransform.add earthOrbit
sunTransform.add mercuryOrbit
sunTransform.add venusOrbit

document.body.appendChild(canvas.domElement)
render()
