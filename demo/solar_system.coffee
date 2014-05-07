`module Two from "two"`

render = ->
  requestAnimationFrame(render)
  renderer.render(root)
  # sunTransform.scale = Math.sin(Date.now() / 5000)

makeImage = (src) ->
  image  = new Image()
  image.src = src
  image

canvas = new Two.Canvas(width: 800, height: 600)
renderer = new Two.SceneRenderer(canvas: canvas)
root = new Two.TransformNode()

root.position = [400, 300]

sunTransform = new Two.TransformNode()
sun = new Two.Sprite(image: makeImage("http://images.nationalgeographic.com/wpf/media-live/photos/000/584/cache/twin-prom-sun_58429_600x450.jpg"), width: 110, height: 100)

earthTransform = new Two.TransformNode()
earth = new Two.Sprite(image: makeImage("http://img4.wikia.nocookie.net/__cb20130212200722/memoryalpha/en/images/3/36/Earth.jpg"), width: 50, height: 50)

root.add sunTransform
sunTransform.add sun
sunTransform.add earthTransform
earthTransform.add earth

document.body.appendChild(canvas.domElement)
render()
