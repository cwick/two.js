`import TwoObject from "./object"`

AssetLoader = TwoObject.extend
  initialize: ->
    @_images = {}

  preloadImage: (name, path) ->
    canvas = document.createElement "canvas"
    @_images[name] = canvas

    image = new Image()
    image.onload = ->
      canvas.width = image.width
      canvas.height = image.height
      context = canvas.getContext "2d"
      context.drawImage image, 0,0

    image.src = path

    return

  loadImage: (name) ->
    @_images[name]

`export default AssetLoader`
