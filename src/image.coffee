define ["signals"], (Signal) ->
  class Image
    constructor: (@path) ->
      @loaded = new Signal()
      @loaded.memorize = true

      @_imageData = new window.Image()
      @_imageData.onload = => @_onImageLoaded()
      @_imageData.src = path

    getImageData: -> @_imageData
    getWidth: ->@_imageData.width
    getHeight: -> @_imageData.height

    @loaded = new Signal()

    _onImageLoaded: ->
      @loaded.dispatch()
      Image.loaded.dispatch()
