define ["signals"], (Signal) ->
  class Image
    constructor: (path) ->
      @_imageData = new window.Image()
      @_imageData.onload = => @loaded.dispatch()
      @_imageData.src = path

    getImageData: -> @_imageData
    getWidth: ->@_imageData.width
    getHeight: -> @_imageData.height

    loaded: new Signal()

    @::loaded.memorize = true

