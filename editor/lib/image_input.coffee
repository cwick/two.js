define ["jquery", "signals", "./control"], ($, Signal, Control) ->
  class ImageInput extends Control
    constructor: ->
      super $("<div/>")

      @changed = new Signal()

      @setValue("<img src='assets/default.png'>")

    getValue: ->
      @_image.get(0)

    setValue: (image) ->
      @$domElement.empty()

      @_image = $(image)
      @_image.addClass "image-input"

      @_image.click =>
        @_fileInput.click()

      @_fileInput = $("<input />", type: "file", style: "display:none", accept: "image/png")
      @_fileInput.change (e) => @_onFileSelected(e)

      @$domElement.append @_image
      @$domElement.append @_fileInput

    _onFileSelected: (e) ->
      file = e.target.files[0]
      return unless file?

      reader = new window.FileReader()
      reader.onload = =>
        image = new window.Image()
        image.onload = => @changed.dispatch()
        image.src = reader.result

        @setValue(image)


      reader.readAsDataURL(file)
