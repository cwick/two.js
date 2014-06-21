`import TwoObject from "./object"`

AssetLoader = TwoObject.extend
  initialize: ->
    @_images = {}
    @baseDir = ""

  preloadImage: (name, path) ->
    unless path?
      path = name
      name = AssetLoader.stripExtension(name)

    canvas = document.createElement "canvas"
    @_images[name] = canvas

    image = new Image()
    image.onload = ->
      canvas.width = image.width
      canvas.height = image.height
      context = canvas.getContext "2d"
      context.drawImage image, 0,0

    image.src = AssetLoader.join(@baseDir, path)

    return

  loadImage: (name) ->
    @_images[name]

AssetLoader.join = (a,b) ->
  if a == "" || b == ""
    a + b
  else
    b = b.substring(1) if b[0] == "/"
    a = a.substring(0, a.length-1) if a[a.length-1] == "/"

    a + "/" + b

AssetLoader.stripExtension = (name) ->
  strippedName = name
  idx = name.lastIndexOf(".")

  if idx != -1
    strippedName = name.substring 0, idx

  strippedName

`export default AssetLoader`
