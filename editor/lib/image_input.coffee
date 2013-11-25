define ["jquery", "signals", "./control"], ($, Signal, Control) ->
  class ImageInput extends Control
    constructor: ->
      super $("<div/>")

      @changed = new Signal()
      @_image = $("<img>", class: "image-input", src: "assets/default.png")
      @_fileInput = $("<input />", type: "file", style: "display:none", accept: "image/png")
      @$domElement.append @_image
      @$domElement.append @_fileInput

      @_fileInput.change (e) => @_onFileSelected(e)

      @_image.click =>
        @_fileInput.click()

    getValue: ->
      image = new window.Image()
      image.src = @_image.get(0).src
      image

    setValue: (data) ->
      @_image.attr "src", data.src

    _onFileSelected: (e) ->
      file = e.target.files[0]
      return unless file?

      reader = new window.FileReader()
      reader.onload = =>
        @_image.attr "src", reader.result
        @changed.dispatch()

      reader.readAsDataURL(file)
