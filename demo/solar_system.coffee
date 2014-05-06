`module Two from "two"`

render = ->
  requestAnimationFrame(render)
  renderer.render(root)

makeImage = (src) ->
  image  = new Image()
  image.src = src
  image

canvas = new Two.Canvas(width: 800, height: 600)
renderer = new Two.SceneRenderer(canvas: canvas)
root = new Two.TransformNode()

root.position = [400, 300]

sunTransform = new Two.TransformNode()
sun = new Two.Sprite(image: makeImage("http://images.nationalgeographic.com/wpf/media-live/photos/000/584/cache/twin-prom-sun_58429_600x450.jpg"))
sunTransform.scale = .2

sunTransform.add sun
root.add sunTransform

document.body.appendChild(canvas.domElement)
render()
