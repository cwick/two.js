define ["signals"], (Signal) ->
  class Image
    constructor: (url, callback) ->
      @loaded = new Signal()
      @loaded.memorize = true
      @loaded.add (=> callback(); return true) if callback?

      @_path = url
      @_loadImage()

    getImageData: -> @_imageData
    getWidth: -> @_imageData?.width
    getHeight: -> @_imageData?.height
    getPath: -> @_path

    _loadImage: ->
      @_imageData = new window.Image()
      @_imageData.onload = => @loaded.dispatch()
      @_imageData.src = @_path
