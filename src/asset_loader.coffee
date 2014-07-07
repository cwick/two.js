`import TwoObject from "./object"`

AssetLoader = TwoObject.extend
  initialize: ->
    @_images = {}
    @_objects = {}
    @baseDir = ""
    @pending = []

  preloadImage: (name, path) ->
    @_preload "images", name, path, (resolve, loader, fullPath, fullName) ->
      canvas = document.createElement "canvas"
      loader._images[fullName] = canvas

      image = new Image()
      image.src = fullPath

      # In Chrome for Mac, drawing an image from a canvas is much
      # faster than drawing from an Image object
      image.onload = ->
        canvas.width = image.width
        canvas.height = image.height
        context = canvas.getContext "2d"
        context.drawImage image, 0,0
        resolve(canvas)

  preloadObject: (name, path) ->
    @_preload "objects", name, path, (resolve, loader, fullPath, fullName) ->
      xhr = new XMLHttpRequest()
      xhr.open "GET", fullPath, true
      xhr.onload = ->
        object = loader._objects[fullName] = JSON.parse(xhr.responseText)
        resolve(object)
      xhr.send()


  _preload: (type, name, path, load) ->
    unless path?
      path = name
      name = AssetLoader.stripExtension(name)

    return if @["_#{type}"][name]?

    loader = @
    path = AssetLoader.join(@baseDir, path)

    promise = new Promise (resolve) ->
      load(resolve, loader, path, name)

    promise.then ->
      loader._resolved(promise)

    loader.pending.push promise

    return

  loadImage: (name) ->
    @_images[name]

  loadObject: (name) ->
    @_objects[name] || throw new Error("JSON objects must be preloaded first")

  _resolved: (promise) ->
    @pending.splice(@pending.indexOf(promise), 1)

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
