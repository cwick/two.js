define ["signals"], (Signal) ->
  class Image
    constructor: (imageOrURL, callback) ->
      @loaded = new Signal()
      @loaded.memorize = true
      @loaded.add (=> callback(); return true) if callback?

      if imageOrURL instanceof window.Image
        @_loadImageData(imageOrURL)
      else if imageOrURL of Image._imageCache
        @_loadCachedImage(imageOrURL)
      else
        @_loadRemoteImage(imageOrURL)

    getImageData: -> @_imageData
    getWidth: -> @_imageData.width
    getHeight: -> @_imageData.height
    getPath: -> @_path

    @_imageCache = {}

    _loadImageData: (image) ->
      @_path = image.name
      @_imageData = image
      window.setTimeout (=> @loaded.dispatch()), 0

    _loadCachedImage: (url) ->
      @_path = url
      @_imageData = Image._imageCache[@_path]
      window.setTimeout (=> @loaded.dispatch()), 0

    _loadRemoteImage: (url) ->
      @_path = url
      @_imageData = Image._imageCache[@_path] = new window.Image()
      @_imageData.onload = => @loaded.dispatch()
      @_imageData.src = @_path
