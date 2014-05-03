`module Two from "two"`

render = ->
  requestAnimationFrame(render)
  renderer.render()

canvas = new Two.Canvas(width: 640, height: 480)
renderer = new Two.SceneRenderer(canvas: canvas)
# frontend = new FrontEnd(new Backend())
# render backend
# scene
# camera
# objects to render
document.body.appendChild(canvas.domElement)
render()
