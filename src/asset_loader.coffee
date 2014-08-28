`import TwoObject from "./object"`
`import ObjectLoader from "./loaders/object_loader"`
`import ImageLoader from "./loaders/image_loader"`
`import SpritesheetLoader from "./loaders/spritesheet_loader"`

AssetLoader = TwoObject.extend
  initialize: ->
    @baseDir = ""
    @pending = []
    @_initializePlugins()

  _preload: (assets, name, load) ->
    shortName = AssetLoader.stripExtension(name)

    return Promise.resolve(assets[shortName]) if assets[shortName]?

    fullPath = AssetLoader.join(@baseDir, name)
    promise = new Promise (resolve) ->
      load(name, fullPath, resolve)

    promise.then (result) =>
      assets[shortName] = result
      @_assetLoaded(promise)

    @pending.push promise

    promise

  _assetLoaded: (promise) ->
    @pending.splice(@pending.indexOf(promise), 1)

  _initializePlugins: ->
    @_loaders = {}
    for type, Plugin of AssetLoader._plugins
      plugin = new Plugin()
      plugin.assets = {}
      plugin.assetLoader = @
      @_loaders[type] = plugin

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

AssetLoader.registerPlugin = (type, Plugin) ->
  capitalizedType = type.charAt(0).toUpperCase() + type.slice(1)

  AssetLoader._plugins ||= {}
  AssetLoader._plugins[type] = Plugin

  AssetLoader.prototype["load#{capitalizedType}"] = (name) ->
    loader = @_loaders[type]
    unless loader.assets[name]?
      throw new Error("#{capitalizedType} objects must be preloaded first")

    loader.assets[name]

  AssetLoader.prototype["preload#{capitalizedType}"] = (name) ->
    loader = @_loaders[type]
    @_preload(loader.assets, name, loader.preload.bind(loader))

AssetLoader.registerPlugin "JSON", ObjectLoader
AssetLoader.registerPlugin "Image", ImageLoader
AssetLoader.registerPlugin "Spritesheet", SpritesheetLoader

`export default AssetLoader`


