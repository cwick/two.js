define ["signals"], (Signal) ->
  class Image
    constructor: (@_path, callback) ->
      @loaded = new Signal()
      @loaded.memorize = true
      @loaded.add (=> callback(); return true) if callback?

      if @_path of Image._imageCache
        @_loadLocalImage()
      else
        @_loadRemoteImage()

    getImageData: -> @_imageData
    getWidth: -> @_imageData.width
    getHeight: -> @_imageData.height
    getPath: -> @_path

    @_imageCache = {}

    _loadLocalImage: ->
      @_imageData = Image._imageCache[@_path]
      window.setTimeout (=> @loaded.dispatch()), 0

    _loadRemoteImage: ->
      @_imageData = Image._imageCache[@_path] = new window.Image()
      @_imageData.onload = => @loaded.dispatch()
      @_imageData.src = @_path
