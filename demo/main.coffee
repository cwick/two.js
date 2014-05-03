`module Two from "two"`

render = ->
  requestAnimationFrame(render)
  renderer.render()

canvas = new Two.Canvas(width: 640, height: 480)
renderer = new Two.SceneRenderer(canvas: canvas)
renderer.backend.imageSmoothingEnabled = false

document.body.appendChild(canvas.domElement)
render()
