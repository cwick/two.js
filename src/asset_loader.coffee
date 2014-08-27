`import TwoObject from "./object"`

AssetLoader = TwoObject.extend
  initialize: ->
    @_images = {}
    @_objects = {}
    @_spritesheets = {}
    @baseDir = ""
    @pending = []

  preloadSpriteSheet: (name) ->
    image = @preloadImage("#{name}.png")
    frames = @preloadObject("#{name}.json")
    spritesheet = Promise.all([image, frames])

    @_preload "spritesheets", name, (resolve, fullPath) ->
      o = {hello: "world"}

      spritesheet.then ->
        resolve(o)

  preloadImage: (name) ->
    @_preload "images", name, (resolve, fullPath) ->
      canvas = document.createElement "canvas"

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

  preloadObject: (name) ->
    @_preload "objects", name, (resolve, fullPath) ->
      xhr = new XMLHttpRequest()
      xhr.open "GET", fullPath, true
      xhr.onload = ->
        resolve(JSON.parse(xhr.responseText))
      xhr.send()


  _preload: (type, name, load) ->
    assets = @["_#{type}"]
    shortName = AssetLoader.stripExtension(name)

    return Promise.resolve(assets[shortName]) if assets[shortName]?

    fullPath = AssetLoader.join(@baseDir, name)
    promise = new Promise (resolve) ->
      load(resolve, fullPath)

    promise.then (result) =>
      assets[shortName] = result
      @_assetLoaded(promise)

    @pending.push promise

    promise

  loadImage: (name) ->
    @_images[name]

  loadObject: (name) ->
    @_objects[name] || throw new Error("JSON objects must be preloaded first")

  loadSpritesheet: (name) ->
    @_spritesheets[name] || throw new Error("Spritesheets must be preloaded first")

  _assetLoaded: (promise) ->
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
